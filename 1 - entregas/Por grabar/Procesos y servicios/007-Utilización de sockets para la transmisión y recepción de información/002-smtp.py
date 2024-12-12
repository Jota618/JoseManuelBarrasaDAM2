import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

# Configuración de la cuenta
smtp_server = "smtp.ionos.es"  # Ejemplo: 'smtp.gmail.com' para Gmail
smtp_port = 587  # Normalmente 587 para SMTP con TLS
username = "dam@jocarsa.com"
password = "TAME123$"

# Crear el mensaje
msg = MIMEMultipart()
msg['From'] = username
msg['To'] = "info@josevicentecarratala.com"
msg['Subject'] = "Asunto del correo desde Python"
# Cuerpo del mensaje
body = "Este es el cuerpo del correo."
msg.attach(MIMEText(body, "plain"))

# Enviar el mensaje
try:
    # Conectar al servidor SMTP
    server = smtplib.SMTP(smtp_server, smtp_port)
    server.starttls()  # Iniciar la conexión segura
    server.login(username, password)
    
    # Enviar el correo
    server.sendmail(msg['From'], msg['To'], msg.as_string())
    print("Correo enviado correctamente")
except Exception as e:
    print(f"Error al enviar el correo: {e}")
finally:
    server.quit()  # Cerrar la conexión
