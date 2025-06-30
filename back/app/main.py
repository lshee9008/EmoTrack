from fastapi import FastAPI
from app.models import DiaryRequest, DiaryResponse
import requests
from app.llama_utils import analyze_diary
from app.weather import get_weather
from app.music import recommend_song

app = FastAPI()

def preload_model():
    try:
        print("모델 preload 중...")
        response = requests.post(
            "http://ollama:11434/api/generate",
            json={
                "model": "llama3.2:3b",
                "prompt": "모델 로딩 테스트입니다.",
                "stream": False
            }
        )
        print("모델 preload 성공:", response.json().get("response", ""))
    except Exception as e:
        print("모델 preload 실패:", e)

@app.on_event("startup")
async def startup_event():
    preload_model()

@app.post("/analyze", response_model=DiaryResponse)
async def analyze(diary: DiaryRequest):
    summary, emotion = analyze_diary(diary.diary)
    # weather = get_weather(diary.date)
    song = recommend_song(emotion)
    # return DiaryResponse(summary=summary, emotion=emotion, weather=weather, song=song)
    return DiaryResponse(summary=summary, emotion=emotion, song=song)
