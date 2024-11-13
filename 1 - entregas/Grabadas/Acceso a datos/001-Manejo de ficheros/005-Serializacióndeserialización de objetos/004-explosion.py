archivo = open("archivo.txt", 'r') # Abre el archivo "archivo.txt" en modo lectura 'r'
contenido = archivo.read() # Lee todo el contenido del archivo y lo guarda en la variable 'contenido'
print(contenido) # Imprime el contenido del archivo

lista = contenido.split("|") # Divide el contenido por el carácter '|' y guarda los elementos en una lista
print(lista) # Imprime la lista resultante después de hacer el split

variable1 = lista[0] # Asigna el primer y segundo elemento de la lista a las variables 'variable1' y 'variable2'
variable2 = lista[1]

print(variable1) # Imprime el valor de 'variable1'
print(variable2)# Imprime el valor de 'variable2'

archivo.close()  # Cerramos el archivo
