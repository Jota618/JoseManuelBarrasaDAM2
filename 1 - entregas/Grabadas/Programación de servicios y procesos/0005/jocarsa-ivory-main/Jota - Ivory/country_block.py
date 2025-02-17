# country_block.py
"""
Módulo para bloquear IPs basándose en el país de origen.
"""

import os
import ipaddress
import geoip2.database
import logging
from collections import defaultdict
from config import LOG_FILE_PATH, GEOIP_DB_PATH, HTACCESS_PATH, BLACKLISTED_COUNTRIES, REQUEST_THRESHOLD, WHITELIST_IPS
from apache_log_parser import parse_log_line
from block_utils import update_htaccess

def get_country(ip, reader, cache):
    """
    Retorna el nombre del país para la IP dada utilizando el lector GeoIP2.
    Utiliza un caché para evitar búsquedas repetidas.
    
    Args:
        ip (str): Dirección IP.
        reader: Objeto reader de geoip2.
        cache (dict): Diccionario de caché.
        
    Returns:
        str: Nombre del país o un indicador de error.
    """
    if ip in cache:
        return cache[ip]
    try:
        response = reader.country(ip)
        country = response.country.name
        cache[ip] = country
        return country
    except geoip2.errors.AddressNotFoundError:
        cache[ip] = "Unknown"
        return "Unknown"
    except ValueError:
        cache[ip] = "Invalid IP"
        return "Invalid IP"
    except Exception as e:
        logging.error(f"Error en la búsqueda GeoIP para la IP {ip}: {e}")
        cache[ip] = "Error"
        return "Error"

def backup_file(file_path, suffix):
    """
    Crea una copia de seguridad del archivo dado agregando un sufijo.
    
    Args:
        file_path (str): Ruta del archivo.
        suffix (str): Sufijo para el backup.
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
    Función principal para procesar el log de Apache y bloquear IPs según país.
    """
    backup_file(HTACCESS_PATH, ".backup_country")

    try:
        with open(LOG_FILE_PATH, 'r') as f:
            lines = f.readlines()
    except Exception as e:
        logging.error(f"Error al leer el archivo de log {LOG_FILE_PATH}: {e}")
        return

    ip_counts = defaultdict(int)
    for line in lines:
        parsed = parse_log_line(line)
        if parsed and 'ip' in parsed:
            ip = parsed['ip']
            try:
                ipaddress.IPv4Address(ip)
                ip_counts[ip] += 1
            except ipaddress.AddressValueError:
                continue

    try:
        reader = geoip2.database.Reader(GEOIP_DB_PATH)
    except Exception as e:
        logging.error(f"Error al abrir la base de datos GeoIP {GEOIP_DB_PATH}: {e}")
        return
    geoip_cache = {}

    country_counts = defaultdict(int)
    unknown_ips = []
    blacklisted_ips = {}
    for ip, count in ip_counts.items():
        # Solo considerar IPs con peticiones por encima del umbral
        if count < REQUEST_THRESHOLD:
            continue
        country = get_country(ip, reader, geoip_cache)
        # Omitir si la IP está en la lista blanca
        if ip in WHITELIST_IPS:
            continue
        if country in BLACKLISTED_COUNTRIES:
            blacklisted_ips[ip] = count
        elif country not in ["Unknown", "Invalid IP", "Error"]:
            country_counts[country] += count
        else:
            unknown_ips.append(ip)

    reader.close()

    logging.info("Peticiones de países permitidos:")
    for country, count in country_counts.items():
        logging.info(f"{country}: {count}")
    logging.info("IPs bloqueadas por país:")
    for ip, count in blacklisted_ips.items():
        logging.info(f"{ip}: {count}")
    logging.info(f"IPs desconocidas/Inválidas: {len(unknown_ips)}")

    try:
        with open('unknown_ips_country.log', 'w') as f:
            for ip in unknown_ips:
                f.write(f"{ip}\n")
        logging.info("IPs desconocidas registradas en unknown_ips_country.log")
    except Exception as e:
        logging.error(f"Error al escribir IPs desconocidas: {e}")

    try:
        with open('blacklisted_ips_country.log', 'w') as f:
            for ip, count in sorted(blacklisted_ips.items(), key=lambda item: item[1], reverse=True):
                f.write(f"{ip} - Count: {count}\n")
        logging.info("IPs bloqueadas por país registradas en blacklisted_ips_country.log")
    except Exception as e:
        logging.error(f"Error al escribir IPs bloqueadas: {e}")

    if blacklisted_ips:
        update_htaccess(blacklisted_ips.keys(), HTACCESS_PATH, "Country")
    else:
        logging.info("No hay IPs para bloquear por país.")

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, format='%(asctime)s [%(levelname)s] %(message)s')
    main()
