<?php

class conexionDB
{
	// Defino una nueva clase para la conexión a la base de datos

	private $servidor;
	private $usuario;
	private $contrasena;
	private $basededatos;
	private $conexion;
	// Propiedades privadas para almacenar los datos de conexión y la conexión misma

	public function __construct()
	{
		// Constructor que inicializa los datos de conexión
		$this->servidor = "localhost";
		$this->usuario = "crimson";
		$this->contrasena = "crimson";
		$this->basededatos = "crimson";
		// Establezco la conexión con la base de datos usando 'mysqli_connect'
		$this->conexion = mysqli_connect($this->servidor, $this->usuario, $this->contrasena, $this->basededatos);
	}

	public function seleccionaTabla($tabla)
	{
		// Método para seleccionar los campos de la tabla y sus restricciones

		$query =
			"
            SELECT * FROM information_schema.key_column_usage WHERE table_name = '" .
			$tabla .
			"';
        ";
		// Consulta para obtener las restricciones de la tabla

		$result = mysqli_query($this->conexion, $query);
		$restricciones = [];
		while ($row = mysqli_fetch_assoc($result)) {
			$restricciones[] = $row;
		}
		var_dump($restricciones);
		// Muestra las restricciones de la tabla (esto es para depuración)

		$query = "SELECT * FROM " . $tabla . ";";
		// Consulta para seleccionar todos los registros de la tabla

		$result = mysqli_query($this->conexion, $query);
		$resultado = [];
		while ($row = mysqli_fetch_assoc($result)) {
			$fila = [];
			foreach ($row as $clave => $valor) {
				$fila[$clave] = $valor;
				echo "La clave " . $clave . " tiene el valor " . $valor;
			}
			$resultado[] = $fila;
		}
		$json = json_encode($resultado, JSON_PRETTY_PRINT);
		// Codifica el resultado como JSON y lo devuelve
		return $json;
	}

	public function listadoTablas()
	{
		// Método para obtener el listado de todas las tablas en la base de datos

		$query = "SHOW TABLES;";
		// Consulta para mostrar todas las tablas

		$result = mysqli_query($this->conexion, $query);
		$resultado = [];
		while ($row = mysqli_fetch_assoc($result)) {
			$fila = [];
			foreach ($row as $clave => $valor) {
				$fila[$clave] = $valor;
			}
			$resultado[] = $fila;
		}
		$json = json_encode($resultado, JSON_PRETTY_PRINT);
		// Codifica el resultado como JSON y lo devuelve
		return $json;
	}

	public function insertaTabla($tabla, $valores)
	{
		// Método para insertar un nuevo registro en la tabla especificada

		$campos = "";
		$datos = "";
		foreach ($valores as $clave => $valor) {
			$campos .= $clave . ",";
			$datos .= "'" . $valor . "',";
		}
		// Formatea los campos y valores para la consulta

		$campos = substr($campos, 0, -1);
		$datos = substr($datos, 0, -1);
		// Elimina la última coma de los strings

		$query =
			"
            INSERT INTO " .
			$tabla .
			" (" .
			$campos .
			") VALUES (" .
			$datos .
			");
        ";
		// Consulta de inserción de los valores

		$result = mysqli_query($this->conexion, $query);
		return 0;
	}

	public function actualizaTabla($tabla, $valores, $id)
	{
		// Método para actualizar un registro en la tabla con un identificador específico

		$query =
			"
            UPDATE " .
			$tabla .
			" SET
        ";
		foreach ($valores as $clave => $valor) {
			$query .= $clave . "='" . $valor . "', ";
		}
		$query = substr($query, 0, -2);
		// Elimina los últimos dos caracteres sobrantes

		$query .=
			"
            WHERE Identificador = " .
			$id .
			";
        ";
		// Condición para identificar el registro a actualizar

		echo $query;
		// Muestra la consulta generada para depuración

		$result = mysqli_query($this->conexion, $query);
		return "";
	}

	public function eliminaTabla($tabla, $id)
	{
		// Método para eliminar un registro de la tabla basándose en su identificador

		$query =
			"
            DELETE FROM " .
			$tabla .
			" WHERE Identificador = " .
			$id .
			";
        ";
		$result = mysqli_query($this->conexion, $query);
	}

	private function codifica($entrada)
	{
		// Método privado para codificar una cadena en base64
		return base64_encode($entrada);
	}

	private function decodifica($entrada)
	{
		// Método privado para decodificar una cadena desde base64
		return base64_decode($entrada);
	}
} ?>

?>
 ?>