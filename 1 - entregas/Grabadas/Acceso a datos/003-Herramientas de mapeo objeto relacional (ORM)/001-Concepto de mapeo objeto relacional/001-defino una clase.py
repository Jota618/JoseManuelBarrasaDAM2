class Persona:
    def __init__(self,
                    nuevonombre,
                    nuevosapellidos,
                    nuevaedad):
        self.nombre = nuevonombre
        self.apellidos = nuevosapellidos
        self.edad = nuevaedad

persona1 = Persona("Jose Vicente","Carratala Sanchis",46)
persona2 = Persona("Juan","Garcia",50)

print(persona1)
