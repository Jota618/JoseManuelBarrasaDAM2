import mysql.connector
###################################### CREO UNA CLASE QUE ES EL MODELO DE DATOS
class Persona:
    def __init__(self,
                    nuevonombre,
                    nuevosapellidos,
                    nuevaedad,
                     nuevoemail,
                 nuevadireccion,
                 nuevostelefonos):
        self.nombre = nuevonombre
        self.apellidos = nuevosapellidos
        self.edad = nuevaedad
        self.email =  nuevoemail
        self.direccion = nuevadireccion
        self.telefonos = nuevostelefonos

##################################### PREPARO UNA CONEXIÓN CON EL SERVIDOR

conexion = mysql.connector.connect(
            host='localhost',  
            database='accesoadatos', 
            user='accesoadatos',  
            password='accesoadatos'  
        )

cursor = conexion.cursor() 

##################################### CREO UNA LISTA DE PERSONAS

personas = []

personas.append(Persona("Jose Vicente","Carratala Sanchis",46,'info@josevicentecarratala.com','La calle de Jose Vicente',[1234,4567]))
personas.append(Persona("Juan","Garcia",36,'juan@garcia.com','La calle de Juan',[3456,6789]))

##################################### BORRAMOS LA TABLA ANTERIOR POR SI ACASO HAY DATOS ANTERIOR

peticion = "DROP TABLE IF EXISTS Persona"
cursor.execute(peticion)

##################################### CREACIÓN DINÁMICA DE LA TABLA EN LA BASE DE DATOS

peticion = "CREATE TABLE IF NOT EXISTS Persona (Identificador INT NOT NULL AUTO_INCREMENT,"                                       # Preparo el principio de la petición

atributos = [attr for attr in dir(personas[0]) if not callable(getattr(personas[0], attr)) and not attr.startswith("__")]   # Listo los atributos de la clase

for atributo in atributos:                                                              # Para cada uno de los atributos
    if not isinstance(getattr(personas[0], atributo), list):
        peticion += atributo+" VARCHAR(255) NOT NULL ,"                                     # Los encadeno a la peticion
    else:
        peticion2 = "DROP TABLE IF EXISTS "+atributo+""
        cursor.execute(peticion2)
        peticion2 = "CREATE TABLE IF NOT EXISTS "+atributo+" (Identificador INT NOT NULL AUTO_INCREMENT,"+atributo+" VARCHAR(255),PRIMARY KEY (Identificador))"
        cursor.execute(peticion2)


peticion += " PRIMARY KEY (Identificador))"                                                                         # Cierro el parentesis de la peticion

print(peticion)
cursor.execute(peticion)                                                                # Ejecuto la peticion

##################################### INSERCIÓN DINÁMICA DE REGISTROS EN LA BASE DE DATOS

for persona in personas:                                                                # PAra cada una de las personas hago un insert
    peticion = "INSERT INTO Persona VALUES(NULL,"                                            # Empiezo a preparar la insercion

    for atributo in atributos:                                                          # Para cada uno de los atributos
        if not isinstance(getattr(persona, atributo), list):
            peticion += "'"+str(getattr(persona, atributo))+"',"                            # Encadeno ese atributo a la peticion de insert
        else:
            for elemento in getattr(persona, atributo):
                peticion2 = "INSERT INTO "+atributo+" VALUES(NULL,'"+str(elemento)+"')"
                cursor.execute(peticion2) 
    peticion = peticion[:-1]                                                            # Le quito la ultima coma
    peticion += ");"                                                                    # Le encadeno el parentesis final
    cursor.execute(peticion)                                                            # Ejecuto la peticion
    
conexion.commit()                                                                       # Lo lanzo todo contra el servidor


















