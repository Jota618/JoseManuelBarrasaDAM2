# pip install SpeechRecognition
# pip install pyaudio

import speech_recognition as sr                                             # Importamos la librería de reconocimiento de voz                              

reconocimiento = sr.Recognizer()                                            # Creamos una instancia del objeto reconocedor

def reconocer():                                                            # creo una función a la que llamar
    with sr.Microphone() as origen:                                         # Obtengo el audio del microfono y lo llamo origen
        print("Ajustando ruido de fondo")                                   # Imprimo un mensaje para decirle al usuario que empezamos a ajustar
        reconocimiento.adjust_for_ambient_noise(origen, duration=1)         # Mido el ruido de fondo que hay en un 1 segundo
        print("Tus opciones:")
        print("1.-INSERTAR un nuevo registro")
        print("2.-LISTAR registros")
        print("3.-ACTUALIZAR un registro")
        print("4.-ELIMINAR un registro")
        print("Escuchamos...")                                              
        audio = reconocimiento.listen(origen)                               # Ahora escucho lo que dice el usuario

        try:                                                                # Como pueden haber fallos
            print("Reconociendo...")                                        # Saco un print en pantalla
            text = reconocimiento.recognize_google(audio, language="es-ES") # Meto lo que google  ha reconocido
            print(f"Reconocido: {text}")                                    # Lo lanzo por pantalla
            if text == "insertar":
                print("operación de insertar reconocida, vamos a inserar un nuevo registro")
            elif text == "listar":
                print("operación de listar reconocida, vamos a por la lista de clientes")
            elif text == "actualizr":
                print("operación de actualizar reconocida, vamos a actualizar un cliente")
            elif text == "eliminar":
                print("operación de listar reconocida, vamos a eliminar un cliente")
            else:
                print("Lo que has dictado no ha sido reconocido")
        except sr.RequestError:                                             # Excepciones en el caso de que no  haber podido reconocer algo
            print("Error 1")
        except sr.UnknownValueError:
            print("Error 2")

reconocer()                                                                 # Ejecuta la función
