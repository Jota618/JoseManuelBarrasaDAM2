import psutil
import time
import os
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

interval = 1
admin_avisado = False

print("Empezamos el cálculo de valores normales")

# Función para enviar correos electrónicos
def envio_correo(destinatario, asunto, cuerpo):
    try:
        # Configuración del servidor SMTP
        smtp_server = "smtp.gmail.com"  # Cambia esto si usas otro proveedor
        smtp_port = 587
        remitente = "dam@jocarsa.com"  # Tu correo electrónico
        contraseña = "TAME123$"  # Tu contraseña

        # Crear el mensaje
        mensaje = MIMEMultipart()
        mensaje["From"] = remitente
        mensaje["To"] = destinatario
        mensaje["Subject"] = asunto
        mensaje.attach(MIMEText(cuerpo, "plain"))

        # Conectarse al servidor y enviar el correo
        servidor = smtplib.SMTP(smtp_server, smtp_port)
        servidor.starttls()  # Iniciar la conexión segura
        servidor.login(remitente, contraseña)
        servidor.sendmail(remitente, destinatario, mensaje.as_string())
        servidor.quit()

        print("Correo enviado con éxito a", destinatario)
    except Exception as e:
        print(f"Error al enviar el correo: {e}")

# Función para calcular el uso de red en un intervalo dado
def get_network_usage(interval):
    initial_net_io = psutil.net_io_counters()
    time.sleep(interval)
    net_io = psutil.net_io_counters()
    subida = (net_io.bytes_sent - initial_net_io.bytes_sent) / interval
    descarga = (net_io.bytes_recv - initial_net_io.bytes_recv) / interval
    return subida, descarga

if not os.path.exists("red.txt"):
    # Calcular valores promedio durante 10 segundos
    total_subida = 0
    total_descarga = 0

    for _ in range(10):
        s, d = get_network_usage(interval)
        total_subida += s
        total_descarga += d

    subida = total_subida / 10
    descarga = total_descarga / 10

    with open("red.txt", 'w') as archivo:
        archivo.write(f"{subida},{descarga}")
else:
    with open("red.txt", 'r') as archivo:
        linea = archivo.readline()

    partido = linea.split(",")
    subida = float(partido[0])
    descarga = float(partido[1])

    # Monitorear uso de red en tiempo real
    previous_net_io = psutil.net_io_counters()

    # Esperar el intervalo antes de calcular el uso de red
    time.sleep(interval)

    # Leer los contadores de red actuales
    current_net_io = psutil.net_io_counters()

    # Calcular uso de red en los últimos 'interval' segundos
    nuevasubida = (current_net_io.bytes_sent - previous_net_io.bytes_sent) / interval
    nuevadescarga = (current_net_io.bytes_recv - previous_net_io.bytes_recv) / interval

    # Verificar anomalías
    if nuevasubida > subida * 15 or nuevadescarga > descarga * 15:
        mensaje = (f"Anomalía detectada: Subida={nuevasubida:.2f} bytes/s, Descarga={nuevadescarga:.2f} bytes/s")
        print(mensaje)

        if not admin_avisado:
            # Enviar correo
            envio_correo(
                destinatario="barrasa618@gmail.com",
                asunto="Anomalía detectada en el servidor",
                cuerpo=f"Se detectó un consumo anormal:\nSubida: {nuevasubida:.2f} bytes/s\nDescarga: {nuevadescarga:.2f} bytes/s"
            )
            admin_avisado = True
    else:
        print(f"Normal: Subida={nuevasubida:.2f} bytes/s, Descarga={nuevadescarga:.2f} bytes/s")
