import azure.functions as func
import azure.durable_functions as df
import json
from openai import AzureOpenAI
from typing import Dict, Any
from azure.identity import DefaultAzureCredential, get_bearer_token_provider
from azure.storage.blob import BlobServiceClient
import time
import os
import logging

logging.basicConfig(level=logging.INFO)


myApp = df.DFApp(http_auth_level=func.AuthLevel.ANONYMOUS)

# An HTTP-Triggered Function with a Durable Functions Client binding
@myApp.route(route="orchestrators/{functionName}")
# @myApp.function_name("http_start")
# @myApp.route(route="http_start")
@myApp.durable_client_input(client_name="client")
async def http_start(req: func.HttpRequest, client):
    function_name = req.route_params.get('functionName')
    logging.warn("starting function_name" + function_name)

    payload = json.loads(req.get_body().decode())
    instance_id = await client.start_new(function_name, client_input=payload)

    response = client.create_check_status_response(req, instance_id)
    return response

# Orchestrator
@myApp.orchestration_trigger(context_name="context")
def assistant_orchestrator(context: df.DurableOrchestrationContext):
    httpbody: Dict[str, Any] = context.get_input()
    result = yield context.call_activity("downloadfile", httpbody)
    return result

# Activity
@myApp.activity_trigger(input_name="httpbody")
def downloadfile(httpbody: str):
    token_provider = get_bearer_token_provider(DefaultAzureCredential(), "https://cognitiveservices.azure.com/.default")
    credential = DefaultAzureCredential()
    try:
        logging.info("Reading the body")
        azure_endpoint = httpbody.get("openai_api_base")
        storage_domain_name = httpbody.get("storage_domain_name")
        storage_container_name = httpbody.get("storage_container_name")
        storage_blob_name = httpbody.get("storage_blob_name")
        deployment=httpbody.get("openai_model")
        category=httpbody.get("category")

        metaprompt = os.environ[f"{category}"]
        if metaprompt == "":
            metaprompt = os.environ["metaprompt"]

    except Exception as e:

        message = f"An error occurred reading the body: {e}"
        logging.info(message)
        return message

    openai_client = AzureOpenAI(
        azure_ad_token_provider=token_provider,
        api_version="2024-02-15-preview",
        azure_endpoint = f"{azure_endpoint}"
    )

    # Create client
    #logging.info("Creating BlobServiceClient: " + {storage_domain_name}  )
    blob_service_client = BlobServiceClient(
        storage_domain_name, credential=credential
    )
    #logging.info("Success Creating BlobServiceClient: " + {storage_domain_name}  )

    #logging.info("Creating storage_container_name: " + {storage_container_name}  )
    blob_client = blob_service_client.get_blob_client(
        container=storage_container_name, blob=storage_blob_name
    )
    #logging.info("Success Creating storage_container_name: " + {storage_domain_name}  )

    try:
    # Download blob
        with open(file=f"/tmp/input_{storage_blob_name}_prompt.json", mode="wb") as transcript:
            download_stream = blob_client.download_blob()
            data = download_stream.readall()
            transcript.write(data)
        #logging.info("File downloaded successfully. Blob name" + {storage_blob_name}  )

    except Exception as e:
        message = (f"An error occurred downloading the file: {e}, {e.args}")
        logging.error(message)
        return message
    try:
        with open(f"/tmp/input_{storage_blob_name}_prompt.json", "rb") as fp: 
            file = openai_client.files.create( 
                file=(f"input_{storage_blob_name}_prompt.json", fp), purpose='assistants' 
                )
            logging.info(f"File status: {file.status}")
    except Exception as e:
        message = (f"An error occurred uploading the file: {e}, {e.args}")
        logging.error(message)
        return message

    # Create an assistant
    try:
        logging.info(f"FileID on input: {file.id}")
        assistant = openai_client.beta.assistants.create(
            name="Video Assistant",
            instructions=metaprompt,
            model=deployment,
            tools=[
                {
                    "type": "code_interpreter"
                }
            ],
            file_ids=[file.id]
        )
    except Exception as e:
        message = (f"An error occurred creating the assistant: {e}, {e.args}")

        logging.info(message)
        return message
    try: 
        thread = openai_client.beta.threads.create()
        oaimessage = openai_client.beta.threads.messages.create(
            thread_id=thread.id,
            role="user",
            content=f"Please summarize the content in the provided file, and create the required JSON file for me to download as a result with the file named as response_{storage_blob_name}"
            #file_id= file.id,
        )
        run = openai_client.beta.threads.runs.create(
            thread_id=thread.id,
            assistant_id=assistant.id,
        )
    except Exception as e:
        message = (f"An error occurred creating the thread: {e}, {e.args}")
        logging.error(message)
        return message
    
    start_time = time.time()

    try: 
        status = run.status
        while status not in ["completed", "cancelled", "expired", "failed"]:
            time.sleep(5)
            run = openai_client.beta.threads.runs.retrieve(thread_id=thread.id,run_id=run.id)
            logging.info("Elapsed time: {} minutes {} seconds".format(int((time.time() - start_time) // 60), int((time.time() - start_time) % 60)))
            status = run.status
            logging.info(f'Status: {status}')
            #clear_output(wait=True)

        messages = openai_client.beta.threads.messages.list(
            thread_id=thread.id
        ) 
        logging.info(f"Messages: {messages.model_dump_json(indent=2)}")
    except Exception as e:
        message = (f"An error occurred running the assistant: {e}, {e.args}")
        logging.error(message)
        return message
    
    try:

        file_ids = [
            file_id for m in messages.data if m.file_ids is not None
                for file_id in m.file_ids
        ]
        
        for file_id in file_ids:
            file_data = openai_client.files.content(file_id)
            file_data_bytes = file_data.read()
            with open(f"/tmp/response_{storage_blob_name}", "wb") as file:
                file.write(file_data_bytes)
            blob_upload_client = blob_service_client.get_blob_client(
                container=storage_container_name, blob=f"response_{storage_blob_name}"
            )
            with open(f"/tmp/response_{storage_blob_name}", "rb") as fp:
                blob_upload_client.upload_blob(fp, overwrite=True)

            logging.info(f"File downloaded successfully {file.name}")
    except Exception as e:
        message = (f"An error occurred downloading the file from the assistant: {e}, {e.args}")
        logging.error(message)
        return message
    else:
        return "succeeded"
