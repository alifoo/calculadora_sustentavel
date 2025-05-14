from fastapi import FastAPI, Request, BackgroundTasks, Response
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
import requests
import json
import os
import base64
import tempfile
import subprocess
from dotenv import load_dotenv

load_dotenv()

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
if not OPENAI_API_KEY:
    print("key da api não encontrada.")

audio_process = None


class PromptRequest(BaseModel):
    prompt: str


class TextToSpeechRequest(BaseModel):
    text: str


@app.post("/ask")
async def ask_ai(data: PromptRequest):
    if not OPENAI_API_KEY:
        return {
            "response": "Error: API key not configured",
            "details": "Set OPENAI_API_KEY in environment variables",
        }

    prompt = data.prompt

    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {OPENAI_API_KEY}",
    }

    payload = {
        "model": "gpt-4o",
        "messages": [
            {
                "role": "user",
                "content": prompt if prompt else "Como ser mais sustentável?",
            }
        ],
        "temperature": 0.7,
    }

    try:
        response = requests.post(
            "https://api.openai.com/v1/chat/completions", headers=headers, json=payload
        )

        if response.status_code == 200:
            result = response.json()
            collected_response = result["choices"][0]["message"]["content"]
            return {"response": collected_response}
        else:
            return {
                "response": f"Error: {response.status_code}",
                "details": response.text,
            }
    except Exception as e:
        return {"response": f"Error connecting to OpenAI API: {str(e)}"}


@app.post("/speak")
async def speak_text(data: TextToSpeechRequest, background_tasks: BackgroundTasks):
    global audio_process

    if not OPENAI_API_KEY:
        return {"success": False, "message": "API key not configured"}

    stop_current_audio()

    text = data.text

    # limpando texto para o tts e limita pra api
    text = text.replace("\n", " ").strip()
    if len(text) > 4000:
        text = text[:4000] + "..."

    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {OPENAI_API_KEY}",
    }

    payload = {
        "model": "tts-1",
        "input": text,
        "voice": "alloy",
        "response_format": "mp3",
    }

    try:
        response = requests.post(
            "https://api.openai.com/v1/audio/speech", headers=headers, json=payload
        )

        if response.status_code == 200:
            # salva o audio em arquivo temp
            with tempfile.NamedTemporaryFile(suffix=".mp3", delete=False) as temp_file:
                temp_file.write(response.content)
                audio_file_path = temp_file.name

            # da play no audio no bg
            background_tasks.add_task(play_audio_file, audio_file_path)

            return {"success": True, "message": "Speaking started"}
        else:
            error_detail = (
                response.json()
                if response.headers.get("content-type") == "application/json"
                else response.text
            )
            return {
                "success": False,
                "message": f"Error {response.status_code}: {error_detail}",
            }
    except Exception as e:
        return {"success": False, "message": f"Error: {str(e)}"}


@app.post("/stop_speaking")
async def stop_speaking():
    """stop any current speech playback"""
    stop_current_audio()
    return {"success": True, "message": "Speech stopped"}


def stop_current_audio():
    """helper function to stop currently playing audio"""
    global audio_process
    if audio_process is not None:
        try:
            audio_process.terminate()
            audio_process = None
        except:
            pass


def play_audio_file(file_path):
    """play audio file using the appropriate system command based on OS"""
    global audio_process

    try:
        if os.name == "nt":
            audio_process = subprocess.Popen(["start", file_path], shell=True)
        elif os.name == "posix":
            if os.path.exists("/usr/bin/afplay"):
                audio_process = subprocess.Popen(["afplay", file_path])
            else:
                if os.path.exists("/usr/bin/mpg123"):
                    audio_process = subprocess.Popen(["mpg123", file_path])
                elif os.path.exists("/usr/bin/mplayer"):
                    audio_process = subprocess.Popen(["mplayer", file_path])
                elif os.path.exists("/usr/bin/vlc"):
                    audio_process = subprocess.Popen(
                        ["vlc", "--play-and-exit", file_path]
                    )
                else:
                    print(
                        "No suitable audio player found. Install mpg123, mplayer, or vlc."
                    )
                    return

        if audio_process:
            audio_process.wait()

        try:
            os.unlink(file_path)
        except:
            pass

        audio_process = None
    except Exception as e:
        print(f"Error playing audio: {str(e)}")


def check_audio_dependencies():
    """check for necessary audio playback stuff"""
    if os.name == "nt":
        return True
    elif os.name == "posix":
        if os.path.exists("/usr/bin/afplay"):
            return True
        else:
            players = ["/usr/bin/mpg123", "/usr/bin/mplayer", "/usr/bin/vlc"]
            for player in players:
                if os.path.exists(player):
                    return True
            print(
                "WARNING: No suitable audio player found. Install mpg123, mplayer, or vlc for TTS playback."
            )
            return False
    return False


@app.on_event("startup")
async def startup_event():
    check_audio_dependencies()
