class Producto:
    def __init__(self):
        self.nombre = ""
        self.descripcion = ""
        self.precio = ""

producto1 = Producto()
producto1.nombre = "Camiseta de deporte"
producto1.descripcion = "Camiseta para hacer deporte"
producto1.precio = 15

print(producto1.precio)
