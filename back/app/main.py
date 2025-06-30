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
                "stream": False,
                # "options": { #옵션을 넣으니 속도가 더 빠른듯 나중에 옵션들 하나하나씩 자세히 봐야함
                #     "num_keep": 5,
                #     "seed": 42,
                #     "num_predict": 100,
                #     "top_k": 20,
                #     "top_p": 0.9,
                #     "min_p": 0.0,
                #     "tfs_z": 0.5,
                #     "typical_p": 0.7,
                #     "repeat_last_n": 33,
                #     "temperature": 0.8,
                #     "repeat_penalty": 1.2,
                #     "presence_penalty": 1.5,
                #     "frequency_penalty": 1.0,
                #     "mirostat": 1,
                #     "mirostat_tau": 0.8,
                #     "mirostat_eta": 0.6,
                #     "penalize_newline": True,
                #     "stop": ["\n", "user:"],
                #     "numa": False,
                #     "num_ctx": 1024,
                #     "num_batch": 2,
                #     "num_gpu": 1,
                #     "main_gpu": 0,
                #     "low_vram": False,
                #     "f16_kv": True,
                #     "vocab_only": False,
                #     "use_mmap": True,
                #     "use_mlock": False,
                #     "num_thread": 8
                # }    
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
