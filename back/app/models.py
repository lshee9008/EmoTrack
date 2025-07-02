from pydantic import BaseModel

class DiaryRequest(BaseModel):
    diary: str
    date: str  # ISO format: YYYY-MM-DD

class Song(BaseModel):
    title: str
    artist: str

class DiaryResponse(BaseModel):
    summary: str
    emotion: str
    weather: str
    song: dict
