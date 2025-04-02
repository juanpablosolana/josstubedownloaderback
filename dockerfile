# Imagen base ligera con Python 3.9
FROM python:3.9-slim

# Instalar FFmpeg y limpiar caché
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Variables de entorno
ENV PYTHONUNBUFFERED=1 \
    PORT=8000

# Directorio de trabajo
WORKDIR /app

# Copiar requirements e instalar dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el código fuente
COPY . .

# Crear carpeta para archivos temporales
RUN mkdir -p temp && \
    chmod -R 777 temp  # Permisos para escritura

# Comando de ejecución (Gunicorn para producción)
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:$PORT", "--workers", "2"]