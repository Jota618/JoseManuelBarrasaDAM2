import imaplib
import email
from email.header import decode_header

# Configuración de la cuenta
username = "dam@jocarsa.com"
password = "TAME123$"
imap_server = "imap.ionos.es"  # Ejemplo: 'imap.gmail.com' para Gmail

# Conectar al servidor IMAP
mail = imaplib.IMAP4_SSL(imap_server)
mail.login(username, password)

# Seleccionar el buzón (INBOX por defecto)
mail.select("inbox")

# Buscar todos los correos electrónicos (puedes ajustar el criterio de búsqueda)
status, messages = mail.search(None, "ALL")

# Obtener la lista de ID de mensajes
mail_ids = messages[0].split()

# Iterar sobre los correos
for mail_id in mail_ids:
    # Recuperar el correo por ID
    status, msg_data = mail.fetch(mail_id, "(RFC822)")
    
    for response_part in msg_data:
        if isinstance(response_part, tuple):
            # Decodificar el mensaje de correo
            msg = email.message_from_bytes(response_part[1])
            # Obtener el asunto (Subject)
            subject, encoding = decode_header(msg["Subject"])[0]
            if isinstance(subject, bytes):
                subject = subject.decode(encoding if encoding else "utf-8")
            print("Asunto:", subject)
            
            # Obtener el remitente (From)
            from_ = msg.get("From")
            print("De:", from_)
            
            # Procesar el contenido del mensaje
            if msg.is_multipart():
                for part in msg.walk():
                    content_type = part.get_content_type()
                    content_disposition = str(part.get("Content-Disposition"))
                    
                    if content_type == "text/plain" and "attachment" not in content_disposition:
                        # Obtener el cuerpo del correo
                        body = part.get_payload(decode=True).decode("utf-8")
                        print("Cuerpo:", body)
            else:
                body = msg.get_payload(decode=True).decode("utf-8")
                print("Cuerpo:", body)
            print("="*50)

# Cerrar conexión
mail.close()
mail.logout()
