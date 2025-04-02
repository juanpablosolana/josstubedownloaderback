from flask import Flask, request, send_file, jsonify
import yt_dlp
import os

app = Flask(__name__)

@app.route('/convert', methods=['GET'])
def convert_to_mp3():
    youtube_url = request.args.get('url')

    if not youtube_url:
        return jsonify({"error": "Se requiere la URL de YouTube"}), 400

    try:
        # Configuración de yt-dlp (con headers y formato m4a para evitar bloqueos)
        ydl_opts = {
            'format': 'bestaudio[ext=m4a]',  # Alternativa a MP3 que suele funcionar
            'outtmpl': 'temp/%(title)s.%(ext)s',
            'postprocessors': [{
                'key': 'FFmpegExtractAudio',
                'preferredcodec': 'mp3',
                'preferredquality': '192',
            }],
            'http_headers': {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                'Accept-Language': 'en-US,en;q=0.9',
            },
            # 'cookiefile': 'cookies.txt',  # Descomenta si tienes cookies (ver README)
        }

        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            info = ydl.extract_info(youtube_url, download=True)
            filename = ydl.prepare_filename(info).replace('.m4a', '.mp3')

        return send_file(filename, as_attachment=True)

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    os.makedirs('temp', exist_ok=True)
    port = int(os.environ.get('PORT', 8000))
    app.run(host='0.0.0.0', port=port)