class Producto:
    def __init__(self):
        self.nombre = ""
        self.descripcion = ""
        self.precio = ""
    def setPrecio(self,nuevoprecio):
        self.precio = nuevoprecio
    def getPrecio(self):
        return self.precio 

producto1 = Producto()
producto1.nombre = "Camiseta de deporte"
producto1.descripcion = "Camiseta para hacer deporte"
producto1.setPrecio(15)

print(producto1.getPrecio())
