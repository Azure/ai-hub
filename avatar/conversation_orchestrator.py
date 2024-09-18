import copy
from sseclient import SSEClient
import requests
import json
import os

class ConversationOrchestrator:
    def __init__(self):
        pass 
    def run_user_query(self):
        pass

    def update_conversation_history(self):
        pass



class PF_Orchestrator(ConversationOrchestrator):
    def __init__(self):
        
        self.pf_endpoint_name=os.environ.get("PF_ENDPOINT_NAME")
        self.pf_deployment_name=os.environ.get("PF_DEPLOYMENT_NAME")
        self.pf_endpoint_key=os.environ.get("PF_ENDPOINT_KEY")
        
        if self.pf_endpoint_name is None or self.pf_endpoint_key is None:
             raise Exception("Prompt Flow end_point or key not provided!")
        
        self.headers = {'Content-Type':'application/json', 'Authorization':('Bearer '+ self.pf_endpoint_key),"Accept": "text/event-stream, application/json"}
        self.history = []

    
    # def _get_payload(self, messages):
    #     _messages = copy.deepcopy(messages)
    #     chat_history = []
    #     chat_input = _messages.pop()['content']

    #     while _messages: #assuming there is always one assistant's answer for each user's question - real?
    #         a=_messages.pop()['content']
    #         q=_messages.pop()['content']
            

    #         chat_history.append({
    #                 "inputs": {
    #                     "question": q,
    #                 },
    #                 "outputs": a,
    #             })

    #     body = {
    #         "question": chat_input,
    #         "chat_history": chat_history,
    #     }

    #     return body

    
    
    def run_user_query(self, user_question):             
        
        body = {
            "question": user_question,
            "chat_history": self.history,
        }

        response = requests.post(self.pf_endpoint_name, json=body, headers=self.headers, stream=True)
        response.raise_for_status()
        
        content_type = response.headers.get('Content-Type')
        assistant_answer = ''
        if "text/event-stream" in content_type:
            client = SSEClient(response)
            for event in client.events():
                dct = json.loads(event.data)
                answer_delta = dct.get('answer')
                if answer_delta:
                    yield answer_delta
                    assistant_answer += answer_delta
        else:
             pass
        
        self.history.append({
            "inputs": {
                "question": user_question,
            },
            "outputs": {
                    "answer": assistant_answer,
            }
        })

        self.prune_history()
    
    
    def prune_history(self):
        pass
                    