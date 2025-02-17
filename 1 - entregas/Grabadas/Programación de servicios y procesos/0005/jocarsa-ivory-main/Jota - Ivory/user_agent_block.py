# user_agent_block.py
"""
Módulo para bloquear IPs basándose en el User Agent.
"""

import os
import ipaddress
import logging
from collections import defaultdict
from config import LOG_FILE_PATH, HTACCESS_PATH, REQUEST_THRESHOLD, WHITELIST_IPS
from apache_log_parser import parse_log_line
from block_utils import update_htaccess

def backup_file(file_path, suffix):
    """
    Crea una copia de seguridad del archivo dado agregando un sufijo.
    """
    if os.path.exists(file_path):
        backup_path = file_path + suffix
        try:
            with open(file_path, 'r') as original, open(backup_path, 'w') as backup:
                backup.write(original.read())
            logging.info(f"Copia de seguridad de {file_path} creada en {backup_path}")
        except Exception as e:
            logging.error(f"Error al crear backup de {file_path}: {e}")

def main():
    """
    Función principal para procesar el log de Apache y bloquear IPs basándose en el User Agent.
    """
    backup_file(HTACCESS_PATH, ".backup_user_agent")
    
    try:
        with open(LOG_FILE_PATH, 'r') as f:
            lines = f.readlines()
    except Exception as e:
        logging.error(f"Error al leer el archivo de log {LOG_FILE_PATH}: {e}")
        return
    
    ip_counts = defaultdict(int)
    blacklisted_ips = set()
    for line in lines:
        parsed = parse_log_line(line)
        if parsed:
            ip = parsed.get('ip')
            user_agent = parsed.get('user_agent', '')
            if ip:
                try:
                    ipaddress.IPv4Address(ip)
                except ipaddress.AddressValueError:
                    continue
                ip_counts[ip] += 1
                # Si el user agent es "-" o está vacío y supera el umbral, se marca para bloqueo
                if user_agent.strip() in ["-", ""] and ip_counts[ip] >= REQUEST_THRESHOLD:
                    if ip not in WHITELIST_IPS:
                        blacklisted_ips.add(ip)
    
    logging.info("IPs bloqueadas por User Agent:")
    for ip in sorted(blacklisted_ips):
        logging.info(ip)
    
    try:
        with open('blacklisted_ips_user_agent.log', 'w') as f:
            for ip in sorted(blacklisted_ips):
                f.write(f"{ip}\n")
        logging.info("IPs bloqueadas por User Agent registradas en blacklisted_ips_user_agent.log")
    except Exception as e:
        logging.error(f"Error al escribir IPs bloqueadas: {e}")
    
    if blacklisted_ips:
        update_htaccess(blacklisted_ips, HTACCESS_PATH, "User Agent")
    else:
        logging.info("No hay IPs para bloquear por User Agent.")

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, format='%(asctime)s [%(levelname)s] %(message)s')
    main()
