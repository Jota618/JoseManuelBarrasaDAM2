

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
personas.append(Persona("Juan","Garcia",36))

atributos = [attr for attr in dir(personas[0]) if not callable(getattr(personas[0], attr)) and not attr.startswith("__")]

print(atributos)
