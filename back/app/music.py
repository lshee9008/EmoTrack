def recommend_song(emotion: str) -> dict:
    song_map = {
        "슬픔": {"title": "Someone Like You", "artist": "Adele"},
        "행복": {"title": "Happy", "artist": "Pharrell Williams"},
        "분노": {"title": "Numb", "artist": "Linkin Park"},
        "중립": {"title": "Life Goes On", "artist": "BTS"},
    }
    return song_map.get(emotion, {"title": "Fix You", "artist": "Coldplay"})
