# main.py
"""
Script principal que ejecuta el bloqueo de IPs por país y por User Agent.
"""

import logging
import os
from country_block import main as country_block_main
from user_agent_block import main as user_agent_block_main
from config import LOG_FILE_PATH

def main():
    # Verificar si el archivo de log existe; si no, crear uno de prueba.
    if not os.path.exists(LOG_FILE_PATH):
        logging.info(f"El archivo de log {LOG_FILE_PATH} no existe. Creando un archivo de prueba.")
        try:
            with open(LOG_FILE_PATH, 'w') as f:
                f.write('127.0.0.1 - - [10/Oct/2023:13:55:36 +0000] "GET / HTTP/1.1" 200 615 "-" "Mozilla/5.0"\n')
        except Exception as e:
            logging.error(f"Error al crear el archivo de prueba: {e}")
            return
    
    logging.info("Iniciando bloqueo de IPs basado en país...")
    country_block_main()
    
    logging.info("Iniciando bloqueo de IPs basado en User Agent...")
    user_agent_block_main()
    
    logging.info("Proceso de bloqueo de IPs completado.")

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, format='%(asctime)s [%(levelname)s] %(message)s')
    main()
