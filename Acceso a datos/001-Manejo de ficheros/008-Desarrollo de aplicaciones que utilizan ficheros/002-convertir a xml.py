import json
import xml.etree.ElementTree as ET

def dict_to_xml(tag, d):
    elem = ET.Element(tag)
    for key, val in d.items():
        child = ET.SubElement(elem, key)
        child.text = str(val)
    return elem

def save_dict_to_xml(filename, root_tag, dictionary):
    root = dict_to_xml(root_tag, dictionary)
    tree = ET.ElementTree(root)
    tree.write(filename, encoding='utf-8', xml_declaration=True)

with open('cliente.json', 'r') as archivo:
    datos = json.load(archivo)

print(datos)
save_dict_to_xml('cliente.xml', 'cliente', datos)




