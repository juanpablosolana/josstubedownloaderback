FROM python:3.9-slim

# 1. Instalar dependencias del sistema
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# 2. Configurar entorno
WORKDIR /app
ENV PYTHONUNBUFFERED=1

# 3. Instalar dependencias (incluyendo gunicorn)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 4. Copiar aplicación
COPY . .

# 5. Preparar carpeta temporal
RUN mkdir -p temp && chmod -R 777 temp

# 6. Comando CORREGIDO (sin problemas de variables)
CMD exec gunicorn --bind 0.0.0.0:$PORT --workers 2 app:app