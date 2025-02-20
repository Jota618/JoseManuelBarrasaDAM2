# block_utils.py
"""
Módulo común para actualizar el archivo .htaccess con reglas de bloqueo.
"""

import os
import logging

def update_htaccess(blacklisted_ips, htaccess_path, marker_name):
    """
    Actualiza el archivo .htaccess agregando las IPs bloqueadas dentro de una sección identificada por 'marker_name'.
    
    Args:
        blacklisted_ips (iterable): Lista o conjunto de IPs a bloquear.
        htaccess_path (str): Ruta al archivo .htaccess.
        marker_name (str): Nombre del criterio (por ejemplo, "Country" o "User Agent") que se usará en los marcadores.
    """
    start_marker = f"# BEGIN Blocked IPs by {marker_name}"
    end_marker = f"# END Blocked IPs by {marker_name}"

    # Leer contenido existente
    if os.path.exists(htaccess_path):
        with open(htaccess_path, 'r') as f:
            lines = f.readlines()
    else:
        lines = []
    
    # Extraer IPs ya bloqueadas en la sección
    existing_ips = set()
    within_block = False
    block_start_index = None
    block_end_index = None

    for index, line in enumerate(lines):
        if line.strip() == start_marker:
            within_block = True
            block_start_index = index
            continue
        if line.strip() == end_marker:
            within_block = False
            block_end_index = index
            break
        if within_block and line.strip().startswith("Require not ip"):
            ip = line.strip().split("Require not ip")[-1].strip()
            existing_ips.add(ip)
    
    # Determinar las nuevas IPs a agregar
    new_ips = set(blacklisted_ips) - existing_ips
    if not new_ips:
        logging.info(f"No hay nuevas IPs para agregar en el bloqueo por {marker_name}.")
        return
    
    # Preparar las reglas a insertar
    block_rules = []
    if block_start_index is not None and block_end_index is not None:
        # Insertar las nuevas reglas antes del marcador de fin
        for ip in new_ips:
            block_rules.append(f"    Require not ip {ip}\n")
        new_lines = lines[:block_end_index] + block_rules + lines[block_end_index:]
        logging.info(f"Agregando {len(new_ips)} nuevas IPs a la sección de bloqueo por {marker_name}.")
    else:
        # Crear la sección completa si no existe
        block_rules = [
            start_marker + "\n",
            "<RequireAll>\n",
            "    Require all granted\n"
        ]
        for ip in new_ips:
            block_rules.append(f"    Require not ip {ip}\n")
        block_rules += [
            "</RequireAll>\n",
            end_marker + "\n"
        ]
        new_lines = lines + ["\n"] + block_rules
        logging.info(f"Creando nueva sección de bloqueo por {marker_name} con {len(new_ips)} IPs.")
    
    try:
        with open(htaccess_path, 'w') as f:
            f.writelines(new_lines)
        logging.info(f".htaccess actualizado correctamente con las nuevas IPs bloqueadas por {marker_name}.")
    except Exception as e:
        logging.error(f"Error al escribir en {htaccess_path}: {e}")
