import os

import json
import requests
from dotenv import load_dotenv
from fastapi import APIRouter, Depends
from fastapi.responses import JSONResponse

# BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
# load_dotenv(os.path.join(BASE_DIR, ".env"))
# 위의 방식은 도커로 컨네이터화 시키기 때문에 파일 디렉터리를 찾지 못해 .env 파일을 찾지 못하는 오류가 있음
load_dotenv("/app/.env")
API_KEY = os.environ["OPENWEATHER_API_KEY"]
city = "Seoul" #도시
apiKey = API_KEY
lang = 'kr' #언어
units = 'metric' #화씨 온도를 섭씨 온도로 변경
    
def get_weather(date: str) -> str:
    
    
    url = f"https://api.openweathermap.org/data/2.5/weather?q={city}&APPID={apiKey}&lang={lang}&units={units}"
    response = requests.get(url)

    try:
        data = response.json()
    except json.JSONDecodeError:
        return f"{date}, 날씨 정보 파싱 실패"

    # 오류 응답 처리
    if response.status_code != 200 or "weather" not in data:
        print("날씨 API 오류 응답:", data)
        return f"{date}, 날씨 정보 조회 실패"

    try:
        description = data['weather'][0]['description']
        temp = data['main']['temp']
        return f"{date}, {city}: {description}, {temp}°C"
    except (KeyError, IndexError) as e:
        print("날씨 데이터 파싱 오류:", e, data)
        return f"{date}, 날씨 정보 파싱 실패"

