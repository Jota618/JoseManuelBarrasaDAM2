import mysql.connector

class Persona:
    def __init__(self,
                    nuevonombre,
                    nuevosapellidos,
                    nuevaedad):
        self.nombre = nuevonombre
        self.apellidos = nuevosapellidos
        self.edad = nuevaedad

personas = []
personas.append(Persona("Jose Vicente","Carratala Sanchis",46))
personas.append(Persona("Juan","Garcia",50))


conexion = mysql.connector.connect(
            host='localhost',  
            database='accesoadatos', 
            user='accesoadatos',  
            password='accesoadatos'  
        )
cursor = conexion.cursor()
for persona in personas:
    peticion = f"""
                INSERT INTO personas VALUES (NULL,'{persona.nombre}','{persona.apellidos}',{persona.edad});
                """
    cursor.execute(peticion)
conexion.commit()
