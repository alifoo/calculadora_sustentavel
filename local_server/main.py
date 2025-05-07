from fastapi import FastAPI, Request
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
import requests
import json

app = FastAPI()

# Optional: allow requests from any origin (Processing app)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

class PromptRequest(BaseModel):
    prompt: str

@app.post("/ask")
async def ask_ai(data: PromptRequest):
    prompt = data.prompt
    url = "http://localhost:11434/api/chat"

    payload = {
        "model": "mistral",
        "messages": [{"role": "user", "content": prompt if prompt else "Como ser mais sustentável?"}]
    }

    response = requests.post(url, json=payload, stream=True)

    if response.status_code == 200:
        collected_response = ""
        for line in response.iter_lines(decode_unicode=True):
            if line:
                try:
                    json_data = json.loads(line)
                    if "message" in json_data and "content" in json_data["message"]:
                        collected_response += json_data["message"]["content"]
                except json.JSONDecodeError:
                    pass
        return {"response": collected_response}
    else:
        return {"response": f"Error: {response.status_code}", "details": response.text}
