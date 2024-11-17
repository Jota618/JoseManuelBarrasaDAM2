import xml.etree.ElementTree as ET
import tkinter as tk
import ttkbootstrap

ventana = tk.Tk()

arbol = ET.parse('013-interfaz.xml') 
raiz = arbol.getroot()

for elemento in raiz:
    if elemento.tag == "boton":
        tk.Button(ventana,text=elemento.text).pack(padx=20,pady=20)
    elif elemento.tag == "texto":
        tk.Label(ventana,text=elemento.text).pack(padx=20,pady=20)
    elif elemento.tag == "entrada":
        tk.Entry(ventana).pack(padx=20,pady=20)

ventana.mainloop()
