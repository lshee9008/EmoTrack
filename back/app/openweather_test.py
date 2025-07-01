import json
import aiohttp
from dotenv import load_dotenv
import os
from fastapi import APIRouter, Depends
from fastapi.responses import JSONResponse

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
load_dotenv(os.path.join(BASE_DIR, ".env"))
API_KEY = os.environ["OPENWEATHER_API_KEY"]
import requests
import json

city = "Seoul" #도시
apiKey = API_KEY
lang = 'kr' #언어
units = 'metric' #화씨 온도를 섭씨 온도로 변경
api = f"https://api.openweathermap.org/data/2.5/weather?q={city}&APPID={apiKey}&lang={lang}&units={units}"

result = requests.get(api)
result = json.loads(result.text)

print(result['main']['temp'])
print(result['weather'][0]['description'])