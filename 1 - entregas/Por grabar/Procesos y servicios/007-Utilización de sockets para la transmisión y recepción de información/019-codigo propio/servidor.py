from funcionescorreo import *  # Importa todas las funciones necesarias desde el módulo funcionescorreo
from flask import Flask, render_template, request, jsonify, send_from_directory  # Importa las clases y funciones de Flask necesarias
import os  # Asegúrate de importar os para la gestión de rutas de archivos

# Crea una instancia de la aplicación Flask
app = Flask(__name__)

# Define una nueva ruta estática para la carpeta `public` (sirve archivos estáticos como imágenes, JS, CSS)
@app.route('/public/<path:filename>')
def public_static(filename):
    # Sirve el archivo solicitado desde la carpeta 'public'
    return send_from_directory(os.path.join(app.root_path, 'public'), filename)

@app.route("/")  # Define la ruta principal (home) de la aplicación
def index():
    # Renderiza y devuelve el archivo HTML de la página principal (index.html)
    return render_template("index.html")  # Renderiza la plantilla HTML

@app.route("/recibir")  # Ruta para recibir correos
def recibir_email():
    # Llama a la función recibir() que obtiene los correos
    return recibir()  # Llama a la función 'recibir' desde el módulo funcionescorreo

@app.route("/enviar", methods=["POST"])  # Ruta para enviar correos (solo acepta peticiones POST)
def enviar_email():
    # Obtiene los datos del correo enviado desde el cuerpo de la petición JSON
    data = request.get_json()  # Recupera los datos en formato JSON
    asunto = data.get("asunto")  # Extrae el asunto del correo
    para = data.get("para")  # Extrae la dirección de correo del destinatario
    mensaje = data.get("mensaje")  # Extrae el cuerpo del correo
    # Llama a la función enviar() para enviar el correo con los datos obtenidos
    enviar("dam@jocarsa.com", para, asunto, mensaje)  # Utiliza la función 'enviar' desde el módulo funcionescorreo
    # Devuelve una respuesta JSON con el estado de la operación
    return jsonify({"status": "ok", "message": "ok"}), 200  # Responde con un código 200 si todo va bien

@app.route("/recibir_por_fecha/<fecha>")  # Ruta para recibir correos filtrados por fecha
def recibir_email_por_fecha(fecha):
    # Llama a la función recibir_por_fecha() con la fecha proporcionada
    mensaje = recibir_por_fecha(fecha)
    if mensaje:
        # Si se encuentra un correo con la fecha, lo devuelve en formato JSON
        return jsonify({"status": "ok", "email": mensaje}), 200  # Devuelve el correo encontrado
    else:
        # Si no se encuentra ningún correo con la fecha, devuelve un error
        return jsonify({"status": "error", "message": "Correo no encontrado para la fecha especificada"}), 404  # Devuelve un error 404 si no se encuentra el correo

# Verifica si el script es ejecutado directamente y arranca la aplicación Flask
if __name__ == "__main__":
    app.run(debug=True)  # Ejecuta la aplicación Flask en modo de depuración (debugging)
