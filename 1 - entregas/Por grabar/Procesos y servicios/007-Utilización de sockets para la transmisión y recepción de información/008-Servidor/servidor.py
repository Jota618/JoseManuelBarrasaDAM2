from funcionescorreo import *
from flask import Flask

app = Flask(__name__)

@app.route("/recibir")
def hello():
    return recibir()

if __name__ == "__main__":
    app.run(debug=True)

