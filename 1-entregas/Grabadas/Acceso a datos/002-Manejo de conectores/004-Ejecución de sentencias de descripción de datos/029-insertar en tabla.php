<?php
ini_set("display_errors", 1); // Activo errores
ini_set("display_startup_errors", 1); // Activo errores de inicio
error_reporting(E_ALL); // Configura el nivel de reporte de errores

class conexionDB // Creo una nueva clase para manejar la conexión a la base de datos
{
	private $servidor; // Almacena el nombre del servidor de la base de datos
	private $usuario; // Almacena el nombre de usuario para la conexión
	private $contrasena; // Almacena la contraseña para la conexión
	private $basededatos; // Almacena el nombre de la base de datos
	private $conexion; // Almacena la conexión a la base de datos

	public function __construct()
	{
		// Constructor de la clase
		// Inicializa las propiedades con los valores de conexión
		$this->servidor = "localhost"; // Establece el servidor como 'localhost'
		$this->usuario = "accesoadatos"; // Establece el usuario
		$this->contrasena = "accesoadatos"; // Establece la contraseña
		$this->basededatos = "accesoadatos"; // Establece la base de datos

		// Establece la conexión a la base de datos MySQL
		$this->conexion = mysqli_connect($this->servidor, $this->usuario, $this->contrasena, $this->basededatos); // Establezco una conexión con la base de datos
	}

	public function seleccionaTabla($tabla)
	{
		// Método para seleccionar registros de una tabla
		$query = "SELECT * FROM " . $tabla . ";"; // Creo la petición dinámica para seleccionar todos los registros
		$result = mysqli_query($this->conexion, $query); // Ejecuto la petición
		$resultado = []; // Creo un array vacío para almacenar los resultados
		while ($row = mysqli_fetch_assoc($result)) {
			// Para cada uno de los registros obtenidos
			//$resultado[] = $row; // Los añado al array (comentado)
			$fila = []; // Inicializo un array para la fila actual
			foreach ($row as $clave => $valor) {
				// Itero sobre cada clave y valor en la fila
				$fila[$clave] = $valor; // Almaceno el valor en el array de fila
			}
			$resultado[] = $fila; // Agrego la fila al array de resultados
		}
		$json = json_encode($resultado, JSON_PRETTY_PRINT); // Codifico el resultado como JSON
		return $json; // Devuelvo el JSON generado
	}

	public function listadoTablas()
	{
		// Método para listar todas las tablas en la base de datos
		$query = "SHOW TABLES;"; // Creo la petición para mostrar las tablas
		$result = mysqli_query($this->conexion, $query); // Ejecuto la petición
		$resultado = []; // Creo un array vacío para almacenar los nombres de las tablas
		while ($row = mysqli_fetch_assoc($result)) {
			// Para cada uno de los registros obtenidos
			//$resultado[] = $row; // Los añado al array (comentado)
			$fila = []; // Inicializo un array para la fila actual
			foreach ($row as $clave => $valor) {
				// Itero sobre cada clave y valor en la fila
				$fila[$clave] = $valor; // Almaceno el valor en el array de fila
			}
			$resultado[] = $fila; // Agrego la fila al array de resultados
		}
		$json = json_encode($resultado, JSON_PRETTY_PRINT); // Codifico el resultado como JSON
		return $json; // Devuelvo el JSON generado
	}

	public function insertaTabla($tabla, $valores)
	{
		// Método para insertar nuevos registros en una tabla
		$campos = ""; // Creo un string para guardar los campos
		$datos = ""; // Creo un string para guardar los datos
		foreach ($valores as $clave => $valor) {
			// Para cada uno de los datos proporcionados
			$campos .= $clave . ","; // Añado el nombre del campo al string
			$datos .= "'" . $valor . "',"; // Añado el dato al string, rodeado de comillas simples
		}
		$campos = substr($campos, 0, -1); // Le quito la última coma al string de campos
		$datos = substr($datos, 0, -1); // Le quito la última coma al string de datos
		$query = "INSERT INTO " . $tabla . " (" . $campos . ") VALUES (" . $datos . ");"; // Preparo la petición de inserción
		$result = mysqli_query($this->conexion, $query); // Ejecuto la petición
		return 0; // Devuelvo 0 para indicar que la inserción fue exitosa
	}

	public function actualizaTabla($tabla, $valores)
	{
		// Método para actualizar registros en una tabla (no implementado)
	}

	public function eliminaTabla($tabla, $id)
	{
		// Método para eliminar registros de una tabla (no implementado)
	}

	private function codifica($entrada)
	{
		// Método privado para codificar una entrada en Base64
		return base64_encode($entrada); // Codifico la entrada en Base64
	}

	private function decodifica($entrada)
	{
		// Método privado para decodificar una entrada en Base64
		return base64_decode($entrada); // Decodifico la entrada de Base64
	}
}

$conexion = new conexionDB(); // Creo una nueva instancia de la clase conexionDB

echo $conexion->insertaTabla("clientes", ["nombre" => "Nombre de prueba", "apellidos" => "Apellidos de prueba"]); // Ejecuto la función de inserción con datos de prueba
?>
