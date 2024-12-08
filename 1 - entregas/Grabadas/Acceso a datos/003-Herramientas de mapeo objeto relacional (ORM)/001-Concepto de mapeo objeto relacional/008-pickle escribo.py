import pickle

class Persona:
    def __init__(self,
                    nuevonombre,
                    nuevosapellidos,
                    nuevaedad,nuevosemails):
        self.nombre = nuevonombre
        self.apellidos = nuevosapellidos
        self.edad = nuevaedad
        self.emails = nuevosemails

personas = []

correosjosevicente = [
        {
        'tipo':'personal',
        'valor':'info@josevicentecarratala.com'
        },
        {
        'tipo':'trabajo',
        'valor':['info@jocarsa.com','jocarsa2@gmail.com']
        }
    ]

personas.append(Persona("Jose Vicente","Carratala Sanchis",46,correosjosevicente))

archivo = open('binario.bin', 'wb')
pickle.dump(personas, archivo)
archivo.close()



