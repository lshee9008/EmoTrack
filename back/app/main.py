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
                "model": "deepseek-r1:8b",
                "prompt": "모델 로딩 테스트입니다.",
                "stream": False,
                "options": {
                    "temperature": 0.8,
                    "num_predict": 100,
                    "top_p": 0.9,
                }
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
    weather = get_weather(diary.date)
    song, youtube_url = recommend_song(emotion)
    response = DiaryResponse(
        summary=summary,
        emotion=emotion,
        weather=weather,
        song=song,
        youtube_url=youtube_url
    )
    print(response)
    return response