import json

agenda = {
    "nombre":"Jose Vicente",
    "apellidos":"Carratala Sanchis",
    "email":"info@josevicentecarratala.com"
    }

archivo = open("agenda.json","w")

json.dump(agenda,archivo)

archivo.close()
