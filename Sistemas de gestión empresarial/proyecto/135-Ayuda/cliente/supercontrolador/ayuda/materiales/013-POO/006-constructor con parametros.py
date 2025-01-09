class Producto:
    def __init__(
                self,
                nuevonombre,
                nuevadescripcion,
                nuevoprecio):
        self.nombre = nuevonombre
        self.descripcion = nuevadescripcion
        self.precio = nuevoprecio
    def setPrecio(self,nuevoprecio):
        if nuevoprecio < 35: 
            self.precio = nuevoprecio
        else:
            print("error")
    def getPrecio(self):
        return self.precio 

producto1 = Producto(
    "Camiseta de deporte",
    "Camiseta para hacer deporte",
    45
    )


print(producto1.getPrecio())
