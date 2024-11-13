<?php
// Define una clase llamada 'conexionDB'
class conexionDB
{
	// Propiedades de la clase para almacenar la configuración de la base de datos
	public $servidor; // Almacena el nombre del servidor de la base de datos
	public $usuario; // Almacena el nombre de usuario para la conexión
	public $contrasena; // Almacena la contraseña para la conexión
	public $basededatos; // Almacena el nombre de la base de datos a la que se conectará

	// Constructor de la clase que se ejecuta al crear una instancia de la clase
	public function __construct()
	{
		// Inicializa las propiedades con los valores de conexión
		$this->servidor = "localhost"; // Establece el servidor como 'localhost'
		$this->usuario = "accesoadatos"; // Establece el usuario
		$this->contrasena = "accesoadatos"; // Establece la contraseña
		$this->basededatos = "accesoadatos"; // Establece la base de datos

		// Establece la conexión a la base de datos MySQL
		$mysqli = mysqli_connect($this->servidor, $this->usuario, $this->contrasena, $this->basededatos); // Conecta al servidor MySQL
	}

	// Método para seleccionar todos los registros de una tabla específica
	public function seleccionaTabla($tabla)
	{
		// Define la consulta SQL para seleccionar todos los registros de la tabla proporcionada
		$query = "SELECT * FROM " . $tabla . ";"; // Crea la consulta SQL usando el nombre de la tabla pasado como argumento

		// Ejecuta la consulta en la base de datos y almacena el resultado
		$result = mysqli_query($mysqli, $query); // Ejecuta la consulta y guarda el resultado en la variable $result

		// Inicializa un array vacío para almacenar los resultados
		$resultado = []; // Crea un array que almacenará todas las filas obtenidas de la consulta

		// Itera sobre cada fila del resultado de la consulta
		while ($row = mysqli_fetch_assoc($result)) {
			// Mientras haya filas en el resultado
			$resultado[] = $row; // Agrega cada fila al array $resultado
		}

		// Convierte el array de resultados a formato JSON con un formato legible
		$json = json_encode($resultado, JSON_PRETTY_PRINT); // Codifica el array $resultado en formato JSON con sangrías para mejor legibilidad

		// Devuelve el JSON generado
		return $json; // Retorna el JSON que contiene los registros de la tabla
	}
}
?>
