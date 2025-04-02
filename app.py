from flask import Flask, request, send_file, jsonify
import yt_dlp
import os

app = Flask(__name__)

@app.route('/convert', methods=['GET'])
def convert_to_mp3():
    youtube_url = request.args.get('url')

    if not youtube_url:
        return jsonify({"error": "Falta la URL de YouTube"}), 400

    try:
        # Configuración para descargar el audio como MP3
        ydl_opts = {
            'format': 'bestaudio/best',
            'postprocessors': [{
                'key': 'FFmpegExtractAudio',
                'preferredcodec': 'mp3',
                'preferredquality': '192',
            }],
            'outtmpl': 'temp/%(title)s.%(ext)s',  # Guarda en carpeta 'temp'
        }

        # Descargar el audio
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            info = ydl.extract_info(youtube_url, download=True)
            filename = ydl.prepare_filename(info).replace('.webm', '.mp3')

        # Enviar el archivo como respuesta
        return send_file(filename, as_attachment=True)

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# ... (código anterior)

if __name__ == '__main__':
    os.makedirs('temp', exist_ok=True)
    port = int(os.environ.get('PORT', 3030))  # Render usa PUERTO dinámico
    app.run(host='0.0.0.0', port=port)  # Quita debug=True en producción