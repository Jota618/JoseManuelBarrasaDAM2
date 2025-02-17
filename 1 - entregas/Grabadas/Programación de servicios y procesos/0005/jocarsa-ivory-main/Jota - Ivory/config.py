# config.py
"""
Archivo de configuración para el proyecto de bloqueo de IPs.
"""

# Rutas de archivos y bases de datos
LOG_FILE_PATH = "/var/log/apache2/jocarsa-oldlace-access.log"
HTACCESS_PATH = "/var/www/html/jocarsa-oldlace/.htaccess"
GEOIP_DB_PATH = "GeoLite2-Country.mmdb"  # Actualiza la ruta si es necesario

# Configuración de bloqueo por país
BLACKLISTED_COUNTRIES = ["China", "Ukraine", "Singapore"]

# Umbral de peticiones para considerar bloquear una IP
REQUEST_THRESHOLD = 10

# Lista blanca (IPs que nunca se bloquearán)
WHITELIST_IPS = []

# Configuración de logging
LOG_LEVEL = "INFO"
LOG_FILE = "app.log"
