FROM python:3.9-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
RUN mkdir -p temp && chmod -R 777 temp

CMD exec gunicorn --bind 0.0.0.0:$PORT --workers 2 --timeout 120 app:app