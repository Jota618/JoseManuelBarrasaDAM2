<?php
ini_set("display_errors", 1); // Habilito la visualización de errores
ini_set("display_startup_errors", 1); // Habilito la visualización de errores durante el arranque
error_reporting(E_ALL); // Establezco que se muestren todos los errores

class conexionDB // Defino la clase 'conexionDB' para manejar la base de datos
{
	private $servidor; // Propiedad privada para almacenar el servidor de la BD
	private $usuario; // Propiedad privada para almacenar el usuario de la BD
	private $contrasena; // Propiedad privada para almacenar la contraseña de la BD
	private $basededatos; // Propiedad privada para almacenar el nombre de la base de datos
	private $conexion; // Propiedad privada para almacenar la conexión a la BD

	public function __construct()
	{
		// Constructor de la clase
		$this->servidor = "localhost"; // Defino el servidor de la BD
		$this->usuario = "accesoadatos"; // Defino el usuario de la BD
		$this->contrasena = "accesoadatos"; // Defino la contraseña de la BD
		$this->basededatos = "accesoadatos"; // Defino el nombre de la BD

		// Establezco la conexión con la base de datos usando mysqli_connect
		$this->conexion = mysqli_connect($this->servidor, $this->usuario, $this->contrasena, $this->basededatos);
	}

	// Método para seleccionar todos los registros de una tabla específica
	public function seleccionaTabla($tabla)
	{
		$query = "SELECT * FROM " . $tabla . ";"; // Defino la consulta para seleccionar todo de la tabla
		$result = mysqli_query($this->conexion, $query); // Ejecuto la consulta
		$resultado = []; // Inicializo un array vacío para almacenar los resultados

		// Itero sobre los resultados y los almaceno en el array
		while ($row = mysqli_fetch_assoc($result)) {
			$fila = [];
			foreach ($row as $clave => $valor) {
				$fila[$clave] = $valor;
			}
			$resultado[] = $fila; // Añado cada fila al array final
		}
		$json = json_encode($resultado, JSON_PRETTY_PRINT); // Codifico el resultado en formato JSON
		return $json; // Devuelvo el JSON resultante
	}

	// Método para obtener un listado de todas las tablas en la base de datos
	public function listadoTablas()
	{
		$query = "SHOW TABLES;"; // Defino la consulta para mostrar todas las tablas
		$result = mysqli_query($this->conexion, $query); // Ejecuto la consulta
		$resultado = []; // Inicializo un array vacío

		// Itero sobre los resultados y los almaceno en el array
		while ($row = mysqli_fetch_assoc($result)) {
			$fila = [];
			foreach ($row as $clave => $valor) {
				$fila[$clave] = $valor;
			}
			$resultado[] = $fila; // Añado cada fila al array
		}
		$json = json_encode($resultado, JSON_PRETTY_PRINT); // Codifico el resultado en formato JSON
		return $json; // Devuelvo el JSON con el listado de tablas
	}

	// Método para insertar un nuevo registro en una tabla específica
	public function insertaTabla($tabla, $valores)
	{
		$campos = ""; // Inicializo un string vacío para los campos
		$datos = ""; // Inicializo un string vacío para los valores

		// Itero sobre los valores recibidos para formar la consulta
		foreach ($valores as $clave => $valor) {
			$campos .= $clave . ","; // Añado el nombre del campo
			$datos .= "'" . $valor . "',"; // Añado el valor entre comillas
		}
		// Elimino la última coma sobrante de ambos strings
		$campos = substr($campos, 0, -1);
		$datos = substr($datos, 0, -1);

		// Defino la consulta para insertar los datos
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
					";
		$result = mysqli_query($this->conexion, $query); // Ejecuto la consulta de inserción
		return 0; // Retorno un valor fijo
	}

	// Método para actualizar registros de una tabla basándose en su ID
	public function actualizaTabla($tabla, $valores, $id)
	{
		$query =
			"
					UPDATE " .
			$tabla .
			" 
					SET
					"; // Empiezo a construir la consulta de actualización

		// Itero sobre los valores para generar las asignaciones en la consulta
		foreach ($valores as $clave => $valor) {
			$query .= $clave . "='" . $valor . "', "; // Asigno los valores correspondientes a cada campo
		}
		$query = substr($query, 0, -2); // Elimino los dos últimos caracteres sobrantes

		// Defino la condición para la actualización basándome en el ID
		$query .=
			"
					WHERE Identificador = " .
			$id .
			"
					";
		echo $query; // Muestra la consulta generada (para propósitos de depuración)
		$result = mysqli_query($this->conexion, $query); // Ejecuto la consulta de actualización
		return ""; // Retorno vacío
	}

	// Método para eliminar un registro de una tabla basándose en su ID
	public function eliminaTabla($tabla, $id)
	{
		// Defino la consulta de eliminación según el ID del registro
		$query =
			"
						DELETE FROM " .
			$tabla .
			" 
						WHERE Identificador = " .
			$id .
			";
						";
		$result = mysqli_query($this->conexion, $query); // Ejecuto la consulta de eliminación
	}

	// Método privado para codificar una entrada en base64
	private function codifica($entrada)
	{
		return base64_encode($entrada);
	}

	// Método privado para decodificar una entrada de base64
	private function decodifica($entrada)
	{
		return base64_decode($entrada);
	}
}

$conexion = new conexionDB(); // Creo una instancia de la clase 'conexionDB'

// Elimina el cliente con ID '4' en la tabla 'clientes'
echo $conexion->eliminaTabla("clientes", "8");
?>