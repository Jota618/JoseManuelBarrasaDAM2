from funcionescorreo import *
from flask import Flask, render_template, request, jsonify, send_from_directory
import os  # Asegúrate de importar os

app = Flask(__name__)

# Define una nueva ruta estática para la carpeta `public`
@app.route('/public/<path:filename>')
def public_static(filename):
    return send_from_directory(os.path.join(app.root_path, 'public'), filename)

@app.route("/")
def index():
    return render_template("index.html")  # Renderiza la página index.html

@app.route("/recibir")
def recibir_email():
    return recibir()  # Llama a la función recibir() desde funcionescorreo
    
@app.route("/enviar", methods=["POST"])
def enviar_email():
    data = request.get_json()
    asunto = data.get("asunto")
    para = data.get("para")
    mensaje = data.get("mensaje")
    enviar("dam@jocarsa.com", para, asunto, mensaje)
    return jsonify({"status": "ok", "message": "ok"}), 200

@app.route("/recibir_por_fecha/<fecha>")
def recibir_email_por_fecha(fecha):
    mensaje = recibir_por_fecha(fecha)
    if mensaje:
        return jsonify({"status": "ok", "email": mensaje}), 200
    else:
        return jsonify({"status": "error", "message": "Correo no encontrado para la fecha especificada"}), 404

if __name__ == "__main__":
    app.run(debug=True)
