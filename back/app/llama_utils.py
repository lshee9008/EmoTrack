import requests

def analyze_diary(diary_text: str) -> tuple[str, str]:
    prompt = f"""
    일기: {diary_text}
    이 일기의 요약과 감정을 다음 형식으로 알려줘:
    요약: ...
    감정: ...
    """

    try:
        response = requests.post(
            "http://ollama:11434/api/generate",
            json={
                "model": "llama3",
                "prompt": prompt,
                "stream": False
            },
            timeout=60
        )
        
        response.raise_for_status()
        output = response.json().get("response", "")
        
        summary = ""
        emotion = ""

        for line in output.strip().split("\n"):
            if "요약:" in line:
                summary = line.split("요약:")[1].strip()
            elif "감정:" in line:
                emotion = line.split("감정:")[1].strip()

        return summary, emotion

    except requests.exceptions.RequestException as e:
        print(f"Error while calling Ollama: {e}")
        if response:
            print(f"Ollama response: {response.text}")
        return "요약 실패", "감정 분석 실패"