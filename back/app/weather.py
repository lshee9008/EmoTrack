import os
import requests
from dotenv import load_dotenv

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
load_dotenv(os.path.join(BASE_DIR, ".env"))
API_KEY = os.environ["OPENWEATHER_API_KEY"]

def get_weather(date: str, city: str = "Seoul") -> str:
    url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_KEY}&units=metric&lang=kr"
    response = requests.get(url).json()

    description = response['weather'][0]['description']
    temp = response['main']['temp']
    return f"{date}, {city}: {description}, {temp}°C"
