from funcionescorreo import *
from flask import Flask, render_template

app = Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html")  # Renders the index.html page

@app.route("/recibir")
def recibir_email():
    return recibir()  # Calls the recibir() function from funcionescorreo

if __name__ == "__main__":
    app.run(debug=True)
