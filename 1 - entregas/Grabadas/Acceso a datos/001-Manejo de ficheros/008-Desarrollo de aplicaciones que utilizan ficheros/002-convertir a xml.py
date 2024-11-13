import json  # Importo la librería para trabajar con archivos JSON
import xml.etree.ElementTree as ET  # Importo el módulo ElementTree para trabajar con XML

# Función para convertir un diccionario en un elemento XML
def dict_to_xml(tag, d):  
    elem = ET.Element(tag)  # Creo un nuevo elemento XML con el nombre del tag
    for key, val in d.items():  # Itero sobre las claves y valores del diccionario
        child = ET.SubElement(elem, key)  # Creo un subelemento para cada clave
        child.text = str(val)  # Establezco el texto del subelemento como el valor
    return elem  # Retorno el elemento XML creado

# Función para guardar un diccionario en un archivo XML
def save_dict_to_xml(filename, root_tag, dictionary):  
    root = dict_to_xml(root_tag, dictionary)  # Convierte el diccionario en un elemento XML
    tree = ET.ElementTree(root)  # Crea un árbol de elementos XML
    tree.write(filename, encoding='utf-8', xml_declaration=True)  # Guarda el árbol en un archivo

# Abro el archivo cliente.json en modo lectura
with open('cliente.json', 'r') as archivo:  
    datos = json.load(archivo)  # Cargo el contenido del archivo JSON en la variable datos

print(datos)  # Imprimo los datos cargados en la consola
# Llamo a la función para guardar los datos en un archivo XML
save_dict_to_xml('cliente.xml', 'cliente', datos)  