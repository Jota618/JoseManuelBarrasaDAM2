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

archivo = open('binario.bin', 'rb')
personas = pickle.load(archivo)
archivo.close()

print(personas)


