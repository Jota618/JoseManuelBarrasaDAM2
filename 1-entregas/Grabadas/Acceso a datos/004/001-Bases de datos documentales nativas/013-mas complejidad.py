from pymongo import MongoClient

cliente = MongoClient("mongodb://localhost:27017/")     # Cambia la URL si tu MongoDB está en otra ubicación
basededatos = cliente["empresa"]                        # Reemplaza con el nombre de tu base de datos
coleccion = basededatos["clientes"]                     # Reemplaza con el nombre de tu colección

cliente = {
    "nombre":"David Manuel",
    "apellidos":"Gonzalez Garcia",
    "correos":[
            {'tipo':'personal','correo':'david@gmail.com'},
            {'tipo':'trabajo','correo':'david@hotmail.com'}
        ]
    }

resultado = coleccion.insert_one(cliente)     

if resultado:
    print("Resultado:", resultado)
else:
    print("Nada que mostrar")
