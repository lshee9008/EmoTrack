FROM python:3.11-slim

RUN apt-get update && apt-get install -y curl \
    && curl -fsSL https://ollama.com/install.sh | sh

# 라마 모델 미리 다운로드하고 실행하지는 않음 (별도 컨테이너 추천)

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
