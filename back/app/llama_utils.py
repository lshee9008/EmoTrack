import requests
import json
import re
from youtubesearchpython import VideosSearch


def analyze_diary(diary_text: str) -> tuple[str, str]:
    prompt = f"""
다음은 사용자의 일기입니다:

\"\"\"{diary_text}\"\"\"

너는 사용자의 하루를 함께 살아가는 비밀 친구야.
진심으로 공감하고 다정하게 위로해주는 말투로 아래 형식에 꼭 맞춰 응답해줘.
**반드시 아래 JSON 형식만** 출력하고, 다른 설명은 절대 붙이지 마.

```json
{{
  "summary": "오늘은 마음이 조금 힘들었지만, 그래도 잘 버텨낸 너는 참 대단해.",
  "emotion": "슬픔"
}}
"""
    try:
        response = requests.post(
            "http://ollama:11434/api/generate",
            json={
                "model": "llama3.2:3b",
                "prompt": prompt,
                "stream": False,
                "options": {
                    "temperature": 0.7,
                    "top_p": 0.9,
                    "num_predict": 200,
                }
            },
            timeout=30
        )
        response.raise_for_status()
        output = response.json().get("response", "").strip()
        print("📥 LLaMA 일기 응답:\n", output)

        match = re.search(r"\{[\s\S]*?\}", output)
        if not match:
            raise ValueError("JSON 응답이 감지되지 않음")

        parsed = json.loads(match.group())

        summary = parsed.get("summary", "요약 실패").strip()
        emotion = parsed.get("emotion", "감정 분석 실패").strip()

        return summary[:100], emotion  # 최대 100자 제한

    except Exception as e:
        print(f"❌ analyze_diary 오류: {e}")
        return "요약 실패", "감정 분석 실패"

