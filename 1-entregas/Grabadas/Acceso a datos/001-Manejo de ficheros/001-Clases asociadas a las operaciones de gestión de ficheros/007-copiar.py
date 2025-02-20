import shutil   #Importamos sutil para añadir funciones de copiar archivos
 
origen = 'origen/documento.txt'    #Carpeta de orgien del archivo
destino = 'destino/documento.txt'  #Carpete de destino
 
shutil.copy(origen, destino)   #Copia el archivo de origen en la carpeta de destino