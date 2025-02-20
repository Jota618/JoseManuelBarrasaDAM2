from pymongo import MongoClient

cliente = MongoClient("mongodb://localhost:27017/")     # Cambia la URL si tu MongoDB está en otra ubicación
basededatos = cliente["empresa"]                        # Reemplaza con el nombre de tu base de datos
coleccion = basededatos["clientes"]                     # Reemplaza con el nombre de tu colección

cliente = {"nombre":"Juan Carlos","apellidos":"Jimenez Garcia"}

resultado = coleccion.insert_one(cliente)     

if resultado:
    print("Resultado:", resultado)
else:
    print("Nada que mostrar")
