export SPEECH_REGION=YOUR_SPEECH_REGION
export SPEECH_KEY=YOUR_SPEECH_KEY
export SPEECH_RESOURCE_URL=https://${SPEECH_REGION}.api.cognitive.microsoft.com/

python3 -m venv ./venv
pip3 install -r requirements.txt
python3 -m flask run -h 0.0.0.0 -p 8080