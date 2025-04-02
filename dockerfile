# Imagen base ligera con Python 3.9
FROM python:3.9-slim

# 1. Instalar FFmpeg y limpiar caché
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# 2. Variables de entorno
ENV PYTHONUNBUFFERED=1 \
    PORT=8000  # Valor por defecto (Render lo sobrescribe)

# 3. Directorio de trabajo
WORKDIR /app

# 4. Copiar requirements e instalar dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copiar el código fuente
COPY . .

# 6. Crear carpeta temporal con permisos
RUN mkdir -p temp && \
    chmod -R 777 temp

# 7. Comando de ejecución (¡CORRECCIÓN CLAVE AQUÍ!)
CMD ["sh", "-c", "gunicorn app:app --bind 0.0.0.0:${PORT} --workers 2"]