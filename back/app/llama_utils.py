import requests
import re

def analyze_diary(diary_text: str) -> tuple[str, str]:
    # 프롬프트: LLM이 정확히 요약과 감정을 정해진 형식으로 출력하게 유도
    prompt = f"""
다음은 사용자의 일기입니다.(꼭! 한국어로 작성해주세요.)
무조건 한국어로 작성해주세요!

\"\"\"{diary_text}\"\"\"

이 일기를 완벽히 분석한 후 아래 형식으로 요약해 주세요:

요약: (하루를 함께 회상하는 말투로 최대 50자 이내로 요약)
감정: (슬픔, 행복, 분노, 중립 중 하나만 정확히 단어로 출력)

형식을 반드시 지켜주세요. 예:
요약: 친구랑 놀아서 즐거운 하루였어
감정: 행복
"""

    try:
        # Ollama 서버로 요청 전송
        print(f"Sending request to Ollama for diary: {diary_text}")
        response = requests.post(
            "http://ollama:11434/api/generate",  # Ollama 서버 주소
            json={
                "model": "deepseek-r1:8b",           # 사용할 모델 지정
                "prompt": prompt,                 # 사용자 일기 + 요청 프롬프트
                "stream": False,                  # 전체 응답을 한 번에 받음
                "options": {
                    "temperature": 0.7,           # 창의성/일관성 조절
                    "top_p": 0.9,
                    "num_predict": 50,           # 예측 최대 길이 (더 길게 확보)
                    
                }
            },
            # timeout=180  # 타임아웃 설정
        )
        response.raise_for_status()  # HTTP 오류 발생 시 예외

        # 응답 텍스트 가져오기
        output = response.json().get("response", "").strip()

        # 원시 응답 출력 (디버깅용)
        print("----- RAW LLaMA OUTPUT -----")
        print(repr(output))  # repr로 \n, \t 등 이스케이프도 확인 가능
        print("----------------------------")

        # 요약 추출: "요약: ..." 또는 "요약 - ..." 등 다양하게 대응
        summary_match = re.search(
            r"요약\s*[:\-]?\s*(.*?)(?=\n|감정\s*[:\-])",
            output,
            re.DOTALL
        )

        # 감정 추출: 감정 키워드 중 하나가 있는지 확인
        emotion_match = re.search(
            r"감정\s*[:\-]?\s*(슬픔|행복|분노|중립)",
            output
        )

        # 결과가 있으면 추출하고 없으면 실패로 처리
        summary = summary_match.group(1).strip()[:50] if summary_match else "요약 실패"
        emotion = emotion_match.group(1).strip() if emotion_match else "감정 분석 실패"

        # 파싱 결과 출력
        print(f"Parsed summary: {summary}, emotion: {emotion}")
        return summary, emotion

    except requests.exceptions.RequestException as e:
        # 네트워크 오류, 시간 초과 등의 예외 처리
        print(f"Error while calling Ollama: {e}")
        return "요약 실패", "감정 분석 실패"