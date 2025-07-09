import json
import re
import requests
from youtubesearchpython import VideosSearch

def recommend_song(emotion: str) -> tuple[dict, str]:
    prompt = f"""
You are a music recommendation assistant.

Given the emotion '{emotion}', recommend one song that matches this mood.
Respond ONLY in this JSON format — absolutely no extra text:

{{
  "title": "Song Title",
  "artist": "Artist Name"
}}
"""

    try:
        response = requests.post(
            "http://ollama:11434/api/generate",
            json={
                "model": "gemma3:4b",
                "prompt": prompt,
                "stream": False,
            },
        )
        response.raise_for_status()
        raw_output = response.json().get("response", "").strip()
        print("📥 LLaMA 노래 추천 응답:\n", raw_output)

        match = re.search(r"\{[\s\S]*?\}", raw_output)
        if match:
            song_data = json.loads(match.group())
        else:
            title_match = re.search(r'"?title"?\s*[:\-]?\s*"([^"]+)"', raw_output, re.IGNORECASE)
            artist_match = re.search(r'"?artist"?\s*[:\-]?\s*"([^"]+)"', raw_output, re.IGNORECASE)

            if title_match and artist_match:
                song_data = {
                    "title": title_match.group(1),
                    "artist": artist_match.group(1)
                }
            else:
                raise ValueError("곡 정보를 파싱할 수 없습니다.")

        if "title" not in song_data or "artist" not in song_data:
            raise ValueError("title 또는 artist 누락됨")

    except Exception as e:
        print(f"❌ recommend_song 오류: {e}")
        song_data = {"title": "Fix You", "artist": "Coldplay"}

    # 🎵 YouTube 검색
    try:
        query = f"{song_data['title']} {song_data['artist']} official"
        search = VideosSearch(query, limit=1)
        result = search.result()
        print("🔍 YouTube 검색 결과:", result)

        if result.get("result") and result["result"]:
            video = result["result"][0]
            video_id = video.get("id")
            youtube_url = f"https://www.youtube.com/watch?v={video_id}" if video_id else video.get("link")
        else:
            raise ValueError("검색 결과 없음")

    except Exception as e:
        print(f"❌ YouTube 검색 오류: {e}")
        # fallback 시에도 watch?v= 형식 유도
        fallback_query = f"{song_data['title']}+{song_data['artist']}+official"
        youtube_url = f"https://www.youtube.com/results?search_query={fallback_query}"

    return song_data, youtube_url
