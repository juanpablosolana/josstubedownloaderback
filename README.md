# YouTube a MP3 API

## Requisitos
1. **FFmpeg instalado** (en Render usa el Dockerfile proporcionado).
2. **Cookies (opcional)**: Si el error persiste:
   - Exporta tus cookies de YouTube con la extensión "Get cookies.txt".
   - Guarda el archivo como `cookies.txt` en la raíz del proyecto.
   - Descomenta la línea `'cookiefile': 'cookies.txt'` en `app.py`.

## Uso
```bash
GET /convert?url=URL_DE_YOUTUBE