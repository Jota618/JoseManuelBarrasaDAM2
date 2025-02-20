import os

def main():
    archivo_log = "/var/log/apache2/jocarsa-oldlace-access.log"

    if not os.path.exists(archivo_log):
        print(f"Error: El archivo {archivo_log} no existe.")
        crear_archivo_prueba = input("¿Deseas crear un archivo de prueba? (s/n): ").strip().lower()
        if crear_archivo_prueba == 's':
            try:
                with open(archivo_log, 'w') as f:
                    f.write("127.0.0.1 - - [10/Oct/2023:13:55:36 +0000] \"GET / HTTP/1.1\" 200 615 \"-\" \"Mozilla/5.0\"\n")
                print(f"Archivo de prueba creado en {archivo_log}")
            except Exception as e:
                print(f"Error al crear el archivo de prueba: {e}")
                return
        else:
            return

    print("Iniciando Bloqueo de IP Basado en País...")
    country_block_main()

    print("\nIniciando Bloqueo de IP Basado en User-Agent...")
    user_agent_block_main()

    print("\nProceso de Bloqueo de IP Completado.")

if __name__ == "__main__":
    main()
