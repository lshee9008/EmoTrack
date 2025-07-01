import requests

def analyze_diary(diary_text: str) -> tuple[str, str]:
    prompt = f"""
    일기: {diary_text}
    이 일기의 요약과 감정을 다음 형식으로 알려줘:
    요약: 내용을 요약해주며 비밀 일기 친구 처럼 하루에 대하여 함께 이야기하는 식으로
    감정: 슬픔, 행복, 분노, 중립 중 하나 선택(단, 그냥 감정 단어만 출력)
    """

    try:
        response = requests.post(
            "http://ollama:11434/api/generate",
            json={
                "model": "llama3.2:3b",  # ✅ 정확한 모델명으로 수정
                "prompt": prompt,
                "stream": False,
                # "options": { #옵션을 넣으니 속도가 더 빠른듯 나중에 옵션들 하나하나씩 자세히 봐야함
                #     "num_keep": 5,
                #     "seed": 42,
                #     "num_predict": 100,
                #     "top_k": 20,
                #     "top_p": 0.9,
                #     "min_p": 0.0,
                #     "tfs_z": 0.5,
                #     "typical_p": 0.7,
                #     "repeat_last_n": 33,
                #     "temperature": 0.8,
                #     "repeat_penalty": 1.2,
                #     "presence_penalty": 1.5,
                #     "frequency_penalty": 1.0,
                #     "mirostat": 1,
                #     "mirostat_tau": 0.8,
                #     "mirostat_eta": 0.6,
                #     "penalize_newline": True,
                #     "stop": ["\n", "user:"],
                #     "numa": False,
                #     "num_ctx": 1024,
                #     "num_batch": 2,
                #     "num_gpu": 1,
                #     "main_gpu": 0,
                #     "low_vram": False,
                #     "f16_kv": True,
                #     "vocab_only": False,
                #     "use_mmap": True,
                #     "use_mlock": False,
                #     "num_thread": 8
                # }    
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
        return "요약 실패", "감정 분석 실패"
