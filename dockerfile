FROM python:3.9-slim

# 1. Instalar dependencias del sistema
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# 2. Instalar dependencias de Python (INCLUYENDO gunicorn)
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 3. Copiar aplicación y configurar
COPY . .
RUN mkdir -p temp && chmod -R 777 temp

CMD ["gunicorn", "--bind", "0. 0.0.0:${PORT}", "app:app"]