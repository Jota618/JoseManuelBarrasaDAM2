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

if __name__ == "__main__":
    app.run(debug=True)
