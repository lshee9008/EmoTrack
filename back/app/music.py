import json
import re
import requests
from youtubesearchpython import VideosSearch

def recommend_song(emotion: str) -> tuple[dict, str]:
    prompt = f"""
Given the emotion '{emotion}', recommend a song that matches this mood.
Respond ONLY in this JSON format — no extra text:

{{
  "title": "Song Title",
  "artist": "Artist Name"
}}
"""

    try:
        response = requests.post(
            "http://ollama:11434/api/generate",
            json={
                "model": "llama3.2:3b",
                "prompt": prompt,
                "stream": False,
                # "options": {
                #     "temperature": 0.7,
                #     "num_predict": 50,
                #     "top_p": 0.9,
                # }
            },
        
        )
        response.raise_for_status()
        raw_output = response.json().get("response", "").strip()
        print("📥 LLaMA 노래 추천 응답:\n", raw_output)

        # JSON 응답 추출 시도
        match = re.search(r"\{[\s\S]*?\}", raw_output)
        if match:
            song_data = json.loads(match.group())
        else:
            # 수동 파싱 시도 (예: "title": "XXX", "artist": "YYY")
            title_match = re.search(r'"?title"?\s*[:\-]?\s*"([^"]+)"', raw_output, re.IGNORECASE)
            artist_match = re.search(r'"?artist"?\s*[:\-]?\s*"([^"]+)"', raw_output, re.IGNORECASE)

            if title_match and artist_match:
                song_data = {
                    "title": title_match.group(1),
                    "artist": artist_match.group(1)
                }
            else:
                raise ValueError("LLaMA 응답에서 곡 정보를 추출할 수 없음")

        if "title" not in song_data or "artist" not in song_data:
            raise ValueError("title 또는 artist 누락")

    except Exception as e:
        print(f"❌ recommend_song 오류: {e}")
        song_data = {"title": "Fix You", "artist": "Coldplay"}

    # YouTube 검색
    try:
        query = f"{song_data['title']} {song_data['artist']} official"
        search = VideosSearch(query, limit=1)
        result = search.result()
        print("🔍 YouTube 검색 결과:", result)

        if result.get("result") and result["result"]:
            video = result["result"][0]
            youtube_url = video.get("link") or f"https://www.youtube.com/results?search_query={query.replace(' ', '+')}"
        else:
            raise ValueError("검색 결과 없음")

    except Exception as e:
        print(f"❌ YouTube 검색 오류: {e}")
        fallback_query = f"{song_data['title']}+{song_data['artist']}+official"
        youtube_url = f"https://www.youtube.com/results?search_query={fallback_query}"

    return song_data, youtube_url
