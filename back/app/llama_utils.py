import requests
import re

def analyze_diary(diary_text: str) -> tuple[str, str]:
    prompt = f"""
다음은 사용자의 일기입니다.

\"\"\"{diary_text}\"\"\"

이 일기를 아래 형식으로 요약해 주세요:

요약: (하루를 함께 회상하는 말투로 최대 50자 이내로 요약)
감정: (슬픔, 행복, 분노, 중립 중 하나만 정확히 단어로 출력)

형식을 반드시 지켜주세요. 예:
요약: 친구랑 놀아서 즐거운 하루였어
감정: 행복
"""

    try:
        print(f"Sending request to Ollama for diary: {diary_text}")
        response = requests.post(
            "http://ollama:11434/api/generate",
            json={
                "model": "llama3.2:3b",
                "prompt": prompt,
                "stream": False,
                "options": {
                    "temperature": 0.7,
                    "top_p": 0.9,
                    "num_predict": 150,
                    "stop": ["\n\n", "user:"],
                }
            },
            timeout=30
        )
        response.raise_for_status()
        output = response.json().get("response", "").strip()
        print("----- RAW LLaMA OUTPUT -----")
        print(repr(output))
        print("----------------------------")

        # 유연한 파싱
        summary_match = re.search(r"요약\s*[:\-]?\s*(.*?)(?=\n|감정\s*[:\-])", output, re.DOTALL)
        emotion_match = re.search(r"감정\s*[:\-]?\s*(슬픔|행복|분노|중립)", output)

        summary = summary_match.group(1).strip()[:50] if summary_match else "요약 실패"
        emotion = emotion_match.group(1).strip() if emotion_match else "감정 분석 실패"

        print(f"Parsed summary: {summary}, emotion: {emotion}")
        return summary, emotion

    except requests.exceptions.RequestException as e:
        print(f"Error while calling Ollama: {e}")
        return "요약 실패", "감정 분석 실패"
