import mysql.connector
###################################### CREO UNA CLASE QUE ES EL MODELO DE DATOS
class Producto:
    def __init__(self,
                    nuevonombre,
                    nuevadescripcion,
                    nuevoprecio,
                     nuevascategorias):
        self.nombre = nuevonombre
        self.descripcion = nuevadescripcion
        self.precio = nuevoprecio
        self.categorias =  nuevascategorias
clase = "Producto"

##################################### PREPARO UNA CONEXIÓN CON EL SERVIDOR

conexion = mysql.connector.connect(
            host='localhost',  
            database='accesoadatos', 
            user='accesoadatos',  
            password='accesoadatos'  
        )

cursor = conexion.cursor() 

##################################### CREO UNA LISTA DE zS

personas = []

personas.append(Producto("Camiseta","Camiseta fenomenal para el dia a dia",34.56,['ropa','caballero']))
personas.append(Producto("Pantalon","Pantalon para vestir de noche",56.43,['ropa','señora']))

##################################### BORRAMOS LA TABLA ANTERIOR POR SI ACASO HAY DATOS ANTERIOR

peticion = "DROP TABLE IF EXISTS "+clase
cursor.execute(peticion)

##################################### CREACIÓN DINÁMICA DE LA TABLA EN LA BASE DE DATOS

peticion = "CREATE TABLE IF NOT EXISTS "+clase+" (Identificador INT NOT NULL AUTO_INCREMENT,"                                       # Preparo el principio de la petición

atributos = [attr for attr in dir(personas[0]) if not callable(getattr(personas[0], attr)) and not attr.startswith("__")]   # Listo los atributos de la clase

for atributo in atributos:                                                              # Para cada uno de los atributos
    if not isinstance(getattr(personas[0], atributo), list):
        peticion += atributo+" VARCHAR(255) NOT NULL ,"                                     # Los encadeno a la peticion
    else:
        peticion2 = "DROP TABLE IF EXISTS "+atributo+""
        cursor.execute(peticion2)
        peticion2 = "CREATE TABLE IF NOT EXISTS "+atributo+" (Identificador INT NOT NULL AUTO_INCREMENT,FK INT(255),"+atributo+" VARCHAR(255),PRIMARY KEY (Identificador))"
        cursor.execute(peticion2)


peticion += " PRIMARY KEY (Identificador))"                                                                         # Cierro el parentesis de la peticion

print(peticion)
cursor.execute(peticion)                                                                # Ejecuto la peticion

##################################### INSERCIÓN DINÁMICA DE REGISTROS EN LA BASE DE DATOS

                                                                                       # PAra cada una de las personas hago un insert
for indice, persona in enumerate(personas):
    peticion = "INSERT INTO "+clase+" VALUES(NULL,"                                            # Empiezo a preparar la insercion

    for atributo in atributos:                                                          # Para cada uno de los atributos
        if not isinstance(getattr(persona, atributo), list):
            peticion += "'"+str(getattr(persona, atributo))+"',"                            # Encadeno ese atributo a la peticion de insert
        else:
            for elemento in getattr(persona, atributo):
                peticion2 = "INSERT INTO "+atributo+" VALUES(NULL,"+str(indice+1)+",'"+str(elemento)+"')"
                cursor.execute(peticion2) 
    peticion = peticion[:-1]                                                            # Le quito la ultima coma
    peticion += ");"                                                                    # Le encadeno el parentesis final
    cursor.execute(peticion)                                                            # Ejecuto la peticion
    
conexion.commit()                                                                       # Lo lanzo todo contra el servidor


















