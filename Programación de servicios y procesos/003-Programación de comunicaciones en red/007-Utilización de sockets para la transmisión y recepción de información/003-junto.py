import imaplib
import email
from email.header import decode_header

import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

# Configuración de la cuenta
username = "dam@jocarsa.com"
password = "TAME123$"
imap_server = "imap.ionos.es"
smtp_server = "smtp.ionos.es"  
smtp_port = 587  

def enviar(desde,para,asunto,mensaje):
    # Crear el mensaje
	msg = MIMEMultipart()
	msg['From'] = desde
	msg['To'] = para
	msg['Subject'] = asunto
	# Cuerpo del mensaje
	body = mensaje
	msg.attach(MIMEText(body, "plain"))

	# Enviar el mensaje
	try:
		 # Conectar al servidor SMTP
		 server = smtplib.SMTP(smtp_server, smtp_port)
		 server.starttls()  # Iniciar la conexión segura
		 server.login(username, password)
		 
		 # Enviar el correo
		 server.sendmail(msg['From'], msg['To'], msg.as_string())
		 return {"mensaje":"Correo enviado correctamente"}
	except Exception as e:
		 return {"mensaje":f"Error{e}"}
	finally:
		 server.quit()  # Cerrar la conexión

def recibir():
    pass
    
enviar("dam@jocarsa.com","info@josevicentecarratala.com","asunto desde Python","Este es un mensaje que te envio")
