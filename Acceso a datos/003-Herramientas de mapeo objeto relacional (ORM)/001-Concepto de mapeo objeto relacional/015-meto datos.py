import mysql.connector

class Persona:
    def __init__(self,
                    nuevonombre,
                    nuevosapellidos,
                    nuevaedad,
                     nuevoemail):
        self.nombre = nuevonombre
        self.apellidos = nuevosapellidos
        self.edad = nuevaedad
        self.email =  nuevoemail

conexion = mysql.connector.connect(
            host='localhost',  
            database='accesoadatos', 
            user='accesoadatos',  
            password='accesoadatos'  
        )

personas = []

personas.append(Persona("Jose Vicente","Carratala Sanchis",46,'info@josevicentecarratala.com'))
personas.append(Persona("Juan","Garcia",36,'juan@garcia.com'))

peticion = "CREATE TABLE IF NOT EXISTS Persona ("

atributos = [attr for attr in dir(personas[0]) if not callable(getattr(personas[0], attr)) and not attr.startswith("__")]

for atributo in atributos:
    peticion += atributo+" VARCHAR(255) NOT NULL ,"

peticion = peticion[:-1]

peticion += ")"
print(peticion)

cursor = conexion.cursor()
cursor.execute(peticion)

for persona in personas:
    peticion = "INSERT INTO Persona VALUES("

    for atributo in atributos:
        print(atributo)
        peticion += "'"+str(getattr(persona, atributo))+"',"
    peticion = peticion[:-1]
    peticion += ");"
    cursor.execute(peticion)

conexion.commit()


















