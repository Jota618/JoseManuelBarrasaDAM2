import xml.etree.ElementTree as ET


arbol = ET.parse('013-interfaz.xml') 
raiz = arbol.getroot()

print(raiz)
for elemento in raiz:
    print(elemento)
