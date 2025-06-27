import requests

def analyze_diary(diary_text: str) -> tuple[str, str]:
    prompt = f"""
    일기: {diary_text}
    이 일기의 요약과 감정을 다음 형식으로 알려줘:
    요약: ...
    감정: ...
    """

    response = requests.post(
        "http://localhost:11434/api/generate",
        json={"model": "llama3", "prompt": prompt, "stream": False}
    )

    output = response.json()["response"]
    lines = output.strip().split("\n")
    summary = lines[0].replace("요약:", "").strip()
    emotion = lines[1].replace("감정:", "").strip()
    return summary, emotion
