

class Persona:
    def __init__(self,
                    nuevonombre,
                    nuevosapellidos,
                    nuevaedad,nuevosemails):
        self.nombre = nuevonombre
        self.apellidos = nuevosapellidos
        self.edad = nuevaedad

personas = []

personas.append(Persona("Jose Vicente","Carratala Sanchis",46))
personas.append(Persona("Juan","Garcia",36))



