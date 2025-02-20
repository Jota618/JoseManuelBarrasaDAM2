# apache_log_parser.py
"""
Módulo para parsear las líneas del log de Apache utilizando expresiones regulares.
"""

import re
import logging

# Patrón para el formato combinado de Apache
LOG_PATTERN = re.compile(
    r'(?P<ip>\S+) '            # IP
    r'\S+ \S+ '                # identd y usuario (se ignoran)
    r'\[(?P<datetime>[^\]]+)\] '  # fecha y hora
    r'"(?P<request>[^"]+)" '    # request
    r'(?P<status>\d{3}) '       # código de estado
    r'(?P<size>\S+) '           # tamaño
    r'"(?P<referer>[^"]*)" '    # referer
    r'"(?P<user_agent>[^"]*)"'  # user agent
)

def parse_log_line(line):
    """
    Parsea una línea del log de Apache y devuelve un diccionario con los campos:
    ip, datetime, request, status, size, referer, user_agent.
    
    Args:
        line (str): Línea del log.
        
    Returns:
        dict o None: Diccionario con la información si coincide el patrón; de lo contrario, None.
    """
    match = LOG_PATTERN.match(line)
    if match:
        return match.groupdict()
    else:
        logging.debug(f"La línea de log no coincide con el patrón: {line}")
        return None
