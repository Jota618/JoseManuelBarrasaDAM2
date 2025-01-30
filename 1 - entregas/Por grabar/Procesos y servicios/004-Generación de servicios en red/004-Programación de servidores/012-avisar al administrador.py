import psutil
import time
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

interval = 1
admin_avisado = False
print("Empezamos el cálculo de valores normales")
def envioCorreo():
    # Email Configuration
    smtp_server = "smtp.ionos.es"  # SMTP server (use Gmail's SMTP server)
    smtp_port = 587                # SMTP port for TLS
    sender_email = "dam@jocarsa.com"   # Replace with your email
    sender_password = "TAME123$"      # Replace with your password
    receiver_email = "info@josevicentecarratala.com"  # Replace with recipient's email

    # Email Content
    subject = "Anomalía detectada"
    body = """
    Hello,

    Que sepas que hay un consumo anormal en tu servidor.

    Best regards,
    Your Name
    """

    try:
        # Create the Email
        message = MIMEMultipart()
        message["From"] = sender_email
        message["To"] = receiver_email
        message["Subject"] = subject

        # Attach the email body
        message.attach(MIMEText(body, "plain"))

        # Connect to the SMTP server
        server = smtplib.SMTP(smtp_server, smtp_port)
        server.starttls()  # Start TLS encryption
        server.login(sender_email, sender_password)  # Login to the email account

        # Send the Email
        server.send_message(message)
        print("Email sent successfully!")

        # Quit the server
        server.quit()

    except Exception as e:
        print(f"Error: {e}")
        
# Function to calculate network usage over a given interval
def get_network_usage(interval):
    initial_net_io = psutil.net_io_counters()
    time.sleep(interval)
    net_io = psutil.net_io_counters()
    subida = (net_io.bytes_sent - initial_net_io.bytes_sent) / interval
    descarga = (net_io.bytes_recv - initial_net_io.bytes_recv) / interval
    return subida, descarga

# Calculate average values over 10 seconds
total_subida = 0
total_descarga = 0

for _ in range(10):
    s, d = get_network_usage(interval)
    total_subida += s
    total_descarga += d

subida = total_subida / 10
descarga = total_descarga / 10
print(f"Valores normales: Subida={subida:.2f} bytes/s, Descarga={descarga:.2f} bytes/s")

print("Ahora comenzamos la toma de datos")

# Monitor real-time network usage
previous_net_io = psutil.net_io_counters()

while True:
    current_net_io = psutil.net_io_counters()
    # Get network usage for the last second
    nuevasubida = (current_net_io.bytes_sent - previous_net_io.bytes_sent) / interval
    nuevadescarga = (current_net_io.bytes_recv - previous_net_io.bytes_recv) / interval
    
    # Update the previous I/O counters
    previous_net_io = current_net_io
    
    # Check for anomalies
    if nuevasubida > subida * 15 or nuevadescarga > descarga * 15:
        print(f"Anomalía detectada: Subida={nuevasubida:.2f} bytes/s, Descarga={nuevadescarga:.2f} bytes/s")
        if admin_avisado == False:
            envioCorreo()
        admin_avisado = True
        
    else:
        print(f"Normal: Subida={nuevasubida:.2f} bytes/s, Descarga={nuevadescarga:.2f} bytes/s")
    
    time.sleep(interval)
