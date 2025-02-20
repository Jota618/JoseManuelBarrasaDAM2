<?php

class conexionDB // Creo una nueva clase
{
	private $servidor; // Propiedad privada para almacenar el servidor
	private $usuario; // Propiedad privada para almacenar el nombre de usuario
	private $contrasena; // Propiedad privada para almacenar la contraseña
	private $basededatos; // Propiedad privada para almacenar la base de datos
	private $conexion; // Propiedad privada para almacenar la conexión

	public function __construct()
	{
		// Constructor de la clase
		$this->servidor = "localhost"; // Inicializo la propiedad con el nombre del servidor
		$this->usuario = "crimson"; // Inicializo la propiedad con el nombre del usuario
		$this->contrasena = "crimson"; // Inicializo la propiedad con la contraseña
		$this->basededatos = "crimson"; // Inicializo la propiedad con el nombre de la base de datos

		$this->conexion = mysqli_connect($this->servidor, $this->usuario, $this->contrasena, $this->basededatos); // Establezco la conexión con la base de datos usando los datos proporcionados
	}

	public function seleccionaTabla($tabla)
	{
		// Método para seleccionar una tabla
		$query =
			"SELECT 
                    *
                  FROM 
                    information_schema.key_column_usage
                  WHERE 
                    table_name = '" .
			$tabla .
			"'
                    AND
                    REFERENCED_TABLE_NAME IS NOT NULL;";
		// Consulta para obtener las restricciones de claves foráneas en la tabla seleccionada

		$result = mysqli_query($this->conexion, $query); // Ejecuto la consulta
		$restricciones = []; // Array para almacenar las restricciones
		while ($row = mysqli_fetch_assoc($result)) {
			// Recorro los resultados de la consulta
			$restricciones[] = $row; // Almaceno cada restricción en el array
		}

		$query = "SELECT * FROM " . $tabla . ";"; // Creo una nueva consulta para seleccionar todos los registros de la tabla
		$result = mysqli_query($this->conexion, $query); // Ejecuto la consulta
		$resultado = []; // Array para almacenar los resultados de la tabla
		while ($row = mysqli_fetch_assoc($result)) {
			// Recorro los resultados de la tabla
			$fila = []; // Array para almacenar cada fila de la tabla
			foreach ($row as $clave => $valor) {
				// Recorro cada columna de la fila
				$pasas = true; // Inicializo la variable para verificar si hay restricciones
				foreach ($restricciones as $restriccion) {
					// Recorro las restricciones
					if ($clave == $restriccion["COLUMN_NAME"]) {
						// Si la columna tiene una restricción
						$fila[$clave] = "datos externos"; // Cambio el valor por un string si tiene una clave foránea
						$pasas = false; // Cambio el estado de la variable
					}
				}
				if ($pasas == true) {
					// Si no hay restricciones
					$fila[$clave] = $valor; // Almaceno el valor real de la columna
				}
			}
			$resultado[] = $fila; // Agrego la fila al array de resultados
		}
		$json = json_encode($resultado, JSON_PRETTY_PRINT); // Codifico los resultados en formato JSON
		return $json; // Devuelvo el JSON resultante
	}

	public function listadoTablas()
	{
		// Método para listar las tablas de la base de datos
		$query = "SHOW TABLES;"; // Consulta para obtener las tablas
		$result = mysqli_query($this->conexion, $query); // Ejecuto la consulta
		$resultado = []; // Array para almacenar las tablas
		while ($row = mysqli_fetch_assoc($result)) {
			// Recorro los resultados de la consulta
			$fila = []; // Array para cada tabla
			foreach ($row as $clave => $valor) {
				$fila[$clave] = $valor; // Almaceno el nombre de la tabla
			}
			$resultado[] = $fila; // Agrego la tabla al array
		}
		$json = json_encode($resultado, JSON_PRETTY_PRINT); // Codifico los resultados en JSON
		return $json; // Devuelvo el JSON resultante
	}

	public function insertaTabla($tabla, $valores)
	{
		// Método para insertar registros en una tabla
		$campos = ""; // String para almacenar los campos
		$datos = ""; // String para almacenar los valores
		foreach ($valores as $clave => $valor) {
			// Recorro los valores proporcionados
			$campos .= $clave . ","; // Agrego los nombres de los campos
			$datos .= "'" . $valor . "',"; // Agrego los valores correspondientes
		}
		$campos = substr($campos, 0, -1); // Quito la última coma del string de campos
		$datos = substr($datos, 0, -1); // Quito la última coma del string de datos
		$query =
			"
            INSERT INTO " .
			$tabla .
			" 
            (" .
			$campos .
			") 
            VALUES (" .
			$datos .
			");
        "; // Creo la consulta de inserción
		$result = mysqli_query($this->conexion, $query); // Ejecuto la consulta
		return 0; // Retorno 0 al finalizar
	}

	public function actualizaTabla($tabla, $valores, $id)
	{
		// Método para actualizar un registro
		$query =
			"
            UPDATE " .
			$tabla .
			" 
            SET
        "; // Empiezo a crear la consulta de actualización
		foreach ($valores as $clave => $valor) {
			// Recorro los valores
			$query .= $clave . "='" . $valor . "', "; // Agrego los valores a actualizar
		}
		$query = substr($query, 0, -2); // Quito la última coma
		$query .=
			"
            WHERE Identificador = " .
			$id .
			"
        "; // Completo la consulta con la condición del identificador
		$result = mysqli_query($this->conexion, $query); // Ejecuto la consulta
		return ""; // Retorno una cadena vacía
	}

	public function eliminaTabla($tabla, $id)
	{
		// Método para eliminar un registro
		$query =
			"
            DELETE FROM " .
			$tabla .
			" 
            WHERE Identificador = " .
			$id .
			";
        "; // Creo la consulta para eliminar el registro
		$result = mysqli_query($this->conexion, $query); // Ejecuto la consulta
	}

	private function codifica($entrada)
	{
		// Método privado para codificar datos en base64
		return base64_encode($entrada);
	}

	private function decodifica($entrada)
	{
		// Método privado para decodificar datos en base64
		return base64_decode($entrada);
	}
}

?>
