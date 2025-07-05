import requests
import re

def analyze_diary(diary_text: str) -> tuple[str, str]:
    # 강화된 프롬프트: 감정, 요약 포맷을 반드시 지키게 유도
    prompt = f"""
다음은 사용자의 일기입니다.

\"\"\"{diary_text}\"\"\"

너는 사용자의 하루를 함께 살아가는 비밀 친구야.  
이 일기를 읽고, 진심으로 공감해주고 위로해주는 말투로 다음 형식에 따라 정확하게 작성해줘.

출력 형식 (반드시 따를 것):
요약: (비밀 친구가 하루를 함께 돌아보며 마음을 어루만지듯 위로해주는 말투로, 감정을 담아 **한글로만**, 최대 100자 이내로 작성할 것.  
오늘 하루에 진심으로 공감하고 다정하게 위로해주는 문장으로 작성할 것. 기계적 표현 금지.)

감정: (슬픔, 행복, 분노, 중립 중 하나의 단어만 **정확히 한 줄로** 출력. 반드시 아래와 같이 작성할 것.)  
예: 감정: 슬픔

"""

    try:
        print(f"Sending request to Ollama for diary:\n{diary_text}\n")
        response = requests.post(
            "http://ollama:11434/api/generate",
            json={
                "model": "llama3.2:3b",
                "prompt": prompt,
                "stream": False,
                "options": {
                    "temperature": 0.7,
                    "top_p": 0.9,
                    "num_predict": 200,  # 조금 더 여유 있게
                    "stop": ["user:", "감정:"],  # "감정:" 이후까지만 생성 유도
                }
            },
            timeout=30
        )
        response.raise_for_status()

        output = response.json().get("response", "").strip()

        print("----- RAW LLaMA OUTPUT -----")
        print(output)
        print("----------------------------")

        # 요약 추출 (줄바꿈 또는 감정으로 끝나도록)
        summary_match = re.search(
            r"요약\s*[:\-]?\s*(.+?)(?=\n\s*감정\s*[:\-])",
            output,
            re.DOTALL | re.IGNORECASE
        )

        # 감정 추출 (한글 감정 키워드만 탐지)
        emotion_match = re.search(
            r"^감정\s*[:\-]?\s*(슬픔|행복|분노|중립)\s*$",
            output,
            re.MULTILINE
        )

        # 파싱 실패 시 대체 처리
        summary = summary_match.group(1).strip() if summary_match else "요약 실패"
        emotion = emotion_match.group(1).strip() if emotion_match else None

        # 감정 누락 시 백업: 요약문 안에서 키워드 탐색
        if not emotion:
            for word in ["슬픔", "행복", "분노", "중립"]:
                if word in output:
                    emotion = word
                    break
            if not emotion:
                emotion = "감정 분석 실패"

        # 요약 100자 이내 제한
        summary = summary[:100]

        print(f"Parsed summary: {summary}, emotion: {emotion}")
        return summary, emotion

    except requests.exceptions.RequestException as e:
        print(f"Error while calling Ollama: {e}")
        return "요약 실패", "감정 분석 실패"
