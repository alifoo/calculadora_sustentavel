import requests
import json
import sys

if len(sys.argv) > 1:
    prompt = sys.argv[1]
else:
    print("No prompt provided")

url = "http://localhost:11434/api/chat"

payload = {
    "model": "mistral",
    "messages": [{"role": "user", "content": prompt if prompt else "Como ser mais sustentável?"}]
}

response = requests.post(url, json=payload, stream=True)

if response.status_code == 200:
    print("Streaming response from Ollama:")
    for line in response.iter_lines(decode_unicode=True):
        if line:
            try:
                json_data = json.loads(line)
                if "message" in json_data and "content" in json_data["message"]:
                        print(json_data["message"]["content"], end="")
            except json.JSONDecodeError:
                print(f"\nFailed to parse line: {line}")
    print()
else:
    print(f"Error: {response.status_code}")
    print(response.text)
