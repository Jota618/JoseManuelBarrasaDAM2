import imaplib
import email
from email.header import decode_header

import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

# Configuración de la cuenta de correo
username = "dam@jocarsa.com"  # Usuario para la cuenta de correo
password = "TAME123$"         # Contraseña de la cuenta de correo
imap_server = "imap.ionos.es" # Servidor IMAP para recibir correos
smtp_server = "smtp.ionos.es" # Servidor SMTP para enviar correos
smtp_port = 587               # Puerto del servidor SMTP

# Función para enviar un correo
def enviar(desde, para, asunto, mensaje):
    # Crear un mensaje multipart (para poder adjuntar archivos si es necesario)
    msg = MIMEMultipart()
    msg['From'] = desde  # Dirección de correo del remitente
    msg['To'] = para     # Dirección de correo del destinatario
    msg['Subject'] = asunto  # Asunto del correo
    
    # El cuerpo del mensaje es el texto del correo
    body = mensaje
    msg.attach(MIMEText(body, "plain"))  # Adjuntar el cuerpo del mensaje como texto plano

    # Enviar el correo
    try:
        # Conectar al servidor SMTP usando el puerto 587 (común para enviar correos)
        server = smtplib.SMTP(smtp_server, smtp_port)
        server.starttls()  # Iniciar la conexión segura (cifrado TLS)
        server.login(username, password)  # Iniciar sesión en el servidor SMTP
        
        # Enviar el correo
        server.sendmail(msg['From'], msg['To'], msg.as_string())  # Enviar el mensaje
        return {"mensaje": "Correo enviado correctamente"}
    except Exception as e:
        # Si ocurre un error, devolver el mensaje de error
        return {"mensaje": f"Error: {e}"}
    finally:
        server.quit()  # Cerrar la conexión al servidor SMTP

# Función para recibir correos
def recibir():
    # Conectar al servidor IMAP con conexión segura
    mail = imaplib.IMAP4_SSL(imap_server)
    mail.login(username, password)  # Iniciar sesión en el servidor IMAP

    # Seleccionar el buzón de entrada (INBOX por defecto)
    mail.select("inbox")

    # Buscar todos los correos electrónicos en el buzón (puedes ajustar el criterio de búsqueda)
    status, messages = mail.search(None, "ALL")

    # Obtener la lista de ID de mensajes
    mail_ids = messages[0].split()

    mensajes = []  # Lista para almacenar los correos

    # Iterar sobre los correos
    for mail_id in mail_ids:
        # Recuperar el correo por ID
        status, msg_data = mail.fetch(mail_id, "(RFC822)")

        for response_part in msg_data:
            if isinstance(response_part, tuple):
                mensaje = {}
                # Decodificar el mensaje de correo
                msg = email.message_from_bytes(response_part[1])
                
                # Obtener el asunto del correo (decodificar si es necesario)
                subject, encoding = decode_header(msg["Subject"])[0]
                if isinstance(subject, bytes):
                    subject = subject.decode(encoding if encoding else "utf-8")
                mensaje["Asunto"] = subject
                
                # Obtener el remitente del correo
                from_ = msg.get("From")
                mensaje["De"] = from_

                # Obtener la fecha del correo
                date = msg.get("Date")
                mensaje["Fecha"] = date

                # Procesar el contenido del correo
                if msg.is_multipart():
                    # Si el mensaje es multipart (tiene varias partes como texto y adjuntos)
                    for part in msg.walk():
                        content_type = part.get_content_type()  # Tipo de contenido (text/plain, etc.)
                        content_disposition = str(part.get("Content-Disposition"))  # Disposición del contenido (si es adjunto)

                        # Si es texto plano y no es un adjunto, procesarlo
                        if content_type == "text/plain" and "attachment" not in content_disposition:
                            body = part.get_payload(decode=True).decode("utf-8")  # Obtener el cuerpo del correo
                            mensaje["Cuerpo"] = body
                else:
                    # Si no es multipart, el mensaje es simple
                    body = msg.get_payload(decode=True).decode("utf-8")
                    mensaje["Cuerpo"] = body
                
                # Añadir el mensaje a la lista de correos
                mensajes.append(mensaje)

    # Cerrar la conexión IMAP
    mail.close()
    mail.logout()
    return mensajes  # Devolver la lista de correos

# Función para recibir un correo filtrado por una fecha específica
def recibir_por_fecha(fecha_objetivo):
    # Conectar al servidor IMAP
    mail = imaplib.IMAP4_SSL(imap_server)
    mail.login(username, password)  # Iniciar sesión en el servidor IMAP

    # Seleccionar el buzón de entrada
    mail.select("inbox")

    # Buscar todos los correos electrónicos
    status, messages = mail.search(None, "ALL")
    mail_ids = messages[0].split()

    # Iterar sobre los correos
    for mail_id in mail_ids:
        # Recuperar el correo por ID
        status, msg_data = mail.fetch(mail_id, "(RFC822)")

        for response_part in msg_data:
            if isinstance(response_part, tuple):
                mensaje = {}
                # Decodificar el mensaje de correo
                msg = email.message_from_bytes(response_part[1])

                # Obtener la fecha del correo
                date = msg.get("Date")
                
                # Comparar la fecha del correo con la fecha objetivo
                if date == fecha_objetivo:
                    # Obtener el asunto del correo
                    subject, encoding = decode_header(msg["Subject"])[0]
                    if isinstance(subject, bytes):
                        subject = subject.decode(encoding if encoding else "utf-8")
                    mensaje["Asunto"] = subject
                    
                    # Obtener el remitente del correo
                    from_ = msg.get("From")
                    mensaje["De"] = from_

                    mensaje["Fecha"] = date

                    # Procesar el contenido del mensaje
                    if msg.is_multipart():
                        for part in msg.walk():
                            content_type = part.get_content_type()
                            content_disposition = str(part.get("Content-Disposition"))
                            
                            if content_type == "text/plain" and "attachment" not in content_disposition:
                                body = part.get_payload(decode=True).decode("utf-8")
                                mensaje["Cuerpo"] = body
                    else:
                        body = msg.get_payload(decode=True).decode("utf-8")
                        mensaje["Cuerpo"] = body

                    # Cerrar la conexión IMAP y devolver el mensaje
                    mail.close()
                    mail.logout()
                    return mensaje

    # Cerrar conexión si no se encontró un correo con la fecha solicitada
    mail.close()
    mail.logout()
    return {"mensaje": "Correo no encontrado para la fecha especificada"}
