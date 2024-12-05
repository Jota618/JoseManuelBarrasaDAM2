from funcionescorreo import *
from flask import Flask, render_template, request, jsonify

app = Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html")  # Renders the index.html page

@app.route("/recibir")
def recibir_email():
    return recibir()  # Calls the recibir() function from funcionescorreo
    
@app.route("/enviar", methods=["POST"])
def enviar_email():
    data = request.get_json()
    asunto = data.get("asunto")
    para = data.get("para")
    mensaje = data.get("mensaje")
    enviar("dam@jocarsa.com",para,asunto,mensaje)
    return jsonify({"status": "ok", "message": "ok"}), 200

@app.route("/recibir_por_fecha/<fecha>")
def recibir_email_por_fecha(fecha):
    # Call recibir_por_fecha() function with the specified date
    mensaje = recibir_por_fecha(fecha)
    if mensaje:
        return jsonify({"status": "ok", "email": mensaje}), 200
    else:
        return jsonify({"status": "error", "message": "Correo no encontrado para la fecha especificada"}), 404
if __name__ == "__main__":
    app.run(debug=True)
