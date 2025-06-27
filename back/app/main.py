from fastapi import FastAPI
from app.models import DiaryRequest, DiaryResponse
from app.llama_utils import analyze_diary
from app.weather import get_weather
from app.music import recommend_song

app = FastAPI()

@app.post("/analyze", response_model=DiaryResponse)
async def analyze(diary: DiaryRequest):
    summary, emotion = analyze_diary(diary.diary)
    weather = get_weather(diary.date)
    song = recommend_song(emotion)
    return DiaryResponse(summary=summary, emotion=emotion, weather=weather, song=song)
