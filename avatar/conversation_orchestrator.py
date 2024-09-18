import copy
from sseclient import SSEClient
import requests
import json
import os

class ConversationOrchestrator:
    def __init__():
        pass 
    def run_user_query(self, messages):
        pass



class PF_Orchestrator(ConversationOrchestrator):
    def __init__(self):
        
        self.pf_endpoint_name="https://okr35-be-chatflow-restep.swedencentral.inference.ml.azure.com/score" #os.environ.get("PF_ENDPOINT_NAME")
        self.pf_deployment_name="okr35-be-chatflow-restep-2" #os.environ.get("PF_DEPLOYMENT_NAME")
        self.pf_endpoint_key="4mvGIXh9XxbO9jKhw6OE83rzZpexSaJ8" #os.environ.get("PF_ENDPOINT_KEY")
        self.headers = {'Content-Type':'application/json', 'Authorization':('Bearer '+ self.pf_endpoint_key),"Accept": "text/event-stream, application/json"}

    
    def _get_payload(self, messages):
        _messages = copy.deepcopy(messages)
        chat_history = []
        chat_input = _messages.pop()['content']

        while _messages: #assuming there is always one assistant's answer for each user's question - real?
            a=_messages.pop()['content']
            q=_messages.pop()['content']
            

            chat_history.append({
                    "inputs": {
                        "question": q,
                    },
                    "outputs": a,
                })

        body = {
            "question": chat_input,
            "chat_history": chat_history,
        }

        return body
    
    def run_user_query(self, messages):             
        
        body = self._get_payload(messages)
        response = requests.post(self.pf_endpoint_name, json=body, headers=self.headers, stream=True)
        response.raise_for_status()
        
        content_type = response.headers.get('Content-Type')
        if "text/event-stream" in content_type:
            client = SSEClient(response)
            for event in client.events():
                dct = json.loads(event.data)
                answer_delta = dct.get('answer')
                if answer_delta:
                    yield answer_delta