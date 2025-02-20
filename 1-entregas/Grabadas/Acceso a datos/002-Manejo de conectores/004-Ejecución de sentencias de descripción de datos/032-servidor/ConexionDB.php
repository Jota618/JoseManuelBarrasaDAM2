<?php

class conexionDB // Defino la clase 'conexionDB'
{
	private $servidor; // Propiedad privada para el servidor
	private $usuario; // Propiedad privada para el usuario
	private $contrasena; // Propiedad privada para la contraseña
	private $basededatos; // Propiedad privada para la base de datos
	private $conexion; // Propiedad privada para almacenar la conexión

	public function __construct()
	{
		// Constructor de la clase 'conexionDB'
		$this->servidor = "localhost"; // Configuro el servidor de la base de datos
		$this->usuario = "crimson"; // Configuro el usuario de la base de datos
		$this->contrasena = "crimson"; // Configuro la contraseña del usuario
		$this->basededatos = "crimson"; // Configuro el nombre de la base de datos

		$this->conexion = mysqli_connect(
			// Establezco la conexión a la base de datos
			$this->servidor,
			$this->usuario,
			$this->contrasena,
			$this->basededatos
		);
	}

	public function seleccionaTabla($tabla)
	{
		// Método para seleccionar registros de una tabla
		$query = "SELECT * FROM " . $tabla . ";"; // Query SQL para obtener todos los registros de una tabla
		$result = mysqli_query($this->conexion, $query); // Ejecuto la consulta
		$resultado = []; // Inicializo un array vacío para almacenar los resultados
		while ($row = mysqli_fetch_assoc($result)) {
			// Recorro cada registro obtenido
			$fila = []; // Array temporal para almacenar los valores del registro
			foreach ($row as $clave => $valor) {
				// Recorro cada columna del registro
				$fila[$clave] = $valor; // Asigno el valor de la columna a la fila
			}
			$resultado[] = $fila; // Agrego la fila al array resultado
		}
		$json = json_encode($resultado, JSON_PRETTY_PRINT); // Codifico los resultados en formato JSON
		return $json; // Devuelvo el JSON
	}

	public function listadoTablas()
	{
		// Método para listar las tablas de la base de datos
		$query = "SHOW TABLES;"; // Query SQL para obtener todas las tablas
		$result = mysqli_query($this->conexion, $query); // Ejecuto la consulta
		$resultado = []; // Inicializo un array vacío
		while ($row = mysqli_fetch_assoc($result)) {
			// Recorro cada tabla obtenida
			$fila = []; // Array temporal para almacenar los nombres de las tablas
			foreach ($row as $clave => $valor) {
				// Recorro los resultados de la consulta
				$fila[$clave] = $valor; // Asigno el nombre de la tabla
			}
			$resultado[] = $fila; // Agrego la tabla al array resultado
		}
		$json = json_encode($resultado, JSON_PRETTY_PRINT); // Codifico los resultados en formato JSON
		return $json; // Devuelvo el JSON
	}

	public function insertaTabla($tabla, $valores)
	{
		// Método para insertar registros en una tabla
		$campos = ""; // Inicializo un string para los campos
		$datos = ""; // Inicializo un string para los valores
		foreach ($valores as $clave => $valor) {
			// Recorro el array de valores a insertar
			$campos .= $clave . ","; // Concateno el nombre del campo
			$datos .= "'" . $valor . "',"; // Concateno el valor del campo
		}
		$campos = substr($campos, 0, -1); // Elimino la última coma del string de campos
		$datos = substr($datos, 0, -1); // Elimino la última coma del string de datos
		$query =
			"                                                       // Defino la consulta SQL de inserción
            INSERT INTO " .
			$tabla .
			" 
            (" .
			$campos .
			") 
            VALUES (" .
			$datos .
			");
        ";
		$result = mysqli_query($this->conexion, $query); // Ejecuto la consulta
		return 0; // Devuelvo 0 (indicando éxito)
	}

	public function actualizaTabla($tabla, $valores, $id)
	{
		// Método para actualizar registros de una tabla
		$query =
			"                                                        // Defino la consulta SQL de actualización
            UPDATE " .
			$tabla .
			" 
            SET
        ";
		foreach ($valores as $clave => $valor) {
			// Recorro los valores a actualizar
			$query .= $clave . "='" . $valor . "', "; // Concateno cada campo con su nuevo valor
		}
		$query = substr($query, 0, -2); // Elimino los últimos dos caracteres (coma y espacio)
		$query .= "WHERE Identificador = " . $id . ""; // Especifico la condición WHERE para actualizar por ID
		echo $query; // Imprimo la consulta SQL generada
		$result = mysqli_query($this->conexion, $query); // Ejecuto la consulta
		return ""; // Devuelvo una cadena vacía
	}

	public function eliminaTabla($tabla, $id)
	{
		// Método para eliminar registros de una tabla
		$query =
			"                                                        // Defino la consulta SQL de eliminación
            DELETE FROM " .
			$tabla .
			" 
            WHERE Identificador = " .
			$id .
			";
        ";
		$result = mysqli_query($this->conexion, $query); // Ejecuto la consulta
	}

	private function codifica($entrada)
	{
		// Método privado para codificar en Base64
		return base64_encode($entrada); // Devuelvo la entrada codificada
	}

	private function decodifica($entrada)
	{
		// Método privado para decodificar de Base64
		return base64_decode($entrada); // Devuelvo la entrada decodificada
	}
}
?>