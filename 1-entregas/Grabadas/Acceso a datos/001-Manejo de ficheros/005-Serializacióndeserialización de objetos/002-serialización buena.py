variable1 = "hola"
variable2 = "que tal"

archivo = open("archivo.txt",'w')
archivo.write(variable1+"|"+variable2)
archivo.close()

