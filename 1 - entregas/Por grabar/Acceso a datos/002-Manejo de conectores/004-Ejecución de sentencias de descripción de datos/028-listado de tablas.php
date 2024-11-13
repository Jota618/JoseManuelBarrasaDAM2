<?php
// Configura la visualización de errores para facilitar la depuración
ini_set("display_errors", 1); // Activa la visualización de errores
ini_set("display_startup_errors", 1); // Activa la visualización de errores de inicio
error_reporting(E_ALL); // Reporta todos los tipos de errores

// Define una clase llamada 'conexionDB'
class conexionDB // Crea una nueva clase para manejar la conexión a la base de datos
{
	// Propiedades privadas para almacenar la configuración de la base de datos
	private $servidor; // Almacena el nombre del servidor de la base de datos
	private $usuario; // Almacena el nombre de usuario para la conexión
	private $contrasena; // Almacena la contraseña para la conexión
	private $basededatos; // Almacena el nombre de la base de datos a la que se conectará
	private $conexion; // Almacena la conexión a la base de datos

	// Constructor de la clase que se ejecuta al crear una instancia de la clase
	public function __construct()
	{
		// Crea un constructor
		// Inicializa las propiedades con los valores de conexión
		$this->servidor = "localhost"; // Establece el servidor como 'localhost'
		$this->usuario = "accesoadatos"; // Establece el usuario
		$this->contrasena = "accesoadatos"; // Establece la contraseña
		$this->basededatos = "accesoadatos"; // Establece la base de datos

		// Establece la conexión a la base de datos MySQL y la almacena en la propiedad $conexion
		$this->conexion = mysqli_connect($this->servidor, $this->usuario, $this->contrasena, $this->basededatos); // Conecta al servidor MySQL
	}

	// Método para seleccionar todos los registros de una tabla específica
	public function seleccionaTabla($tabla)
	{
		// Crea un método de selección
		// Define la consulta SQL para seleccionar todos los registros de la tabla proporcionada
		$query = "SELECT * FROM " . $tabla . ";"; // Crea la consulta SQL usando el nombre de la tabla pasado como argumento

		// Ejecuta la consulta en la base de datos y almacena el resultado
		$result = mysqli_query($this->conexion, $query); // Ejecuta la consulta y guarda el resultado en la variable $result

		// Inicializa un array vacío para almacenar los resultados
		$resultado = []; // Crea un array que almacenará todas las filas obtenidas de la consulta

		// Itera sobre cada fila del resultado de la consulta
		while ($row = mysqli_fetch_assoc($result)) {
			// Mientras haya filas en el resultado
			// Crea un array para almacenar los valores de la fila
			$fila = []; // Inicializa un array para la fila actual

			// Itera sobre cada clave y valor en la fila
			foreach ($row as $clave => $valor) {
				// Para cada uno de los registros
				$fila[$clave] = $valor; // Almacena el valor en el array de fila
			}
			$resultado[] = $fila; // Agrega la fila al array $resultado
		}

		// Convierte el array de resultados a formato JSON con un formato legible
		$json = json_encode($resultado, JSON_PRETTY_PRINT); // Codifica el array $resultado en formato JSON con sangrías para mejor legibilidad

		// Devuelve el JSON generado
		return $json; // Retorna el JSON que contiene los registros de la tabla
	}

	// Método para listar todas las tablas en la base de datos
	public function listadoTablas()
	{
		// Crea un método para listar las tablas
		$query = "SHOW TABLES;"; // Crea la consulta SQL para mostrar las tablas
		$result = mysqli_query($this->conexion, $query); // Ejecuta la consulta y guarda el resultado

		// Inicializa un array vacío para almacenar los nombres de las tablas
		$resultado = []; // Crea un array que almacenará los nombres de las tablas

		// Itera sobre cada fila del resultado de la consulta
		while ($row = mysqli_fetch_assoc($result)) {
			// Mientras haya filas en el resultado
			// Crea un array para almacenar los nombres de las tablas
			$fila = []; // Inicializa un array para la fila actual

			// Itera sobre cada clave y valor en la fila
			foreach ($row as $clave => $valor) {
				// Para cada uno de los registros
				$fila[$clave] = $valor; // Almacena el valor en el array de fila
			}
			$resultado[] = $fila; // Agrega la fila al array $resultado
		}

		// Convierte el array de resultados a formato JSON con un formato legible
		$json = json_encode($resultado, JSON_PRETTY_PRINT); // Codifica el array $resultado en formato JSON con sangrías para mejor legibilidad

		// Devuelve el JSON generado
		return $json; // Retorna el JSON que contiene los nombres de las tablas
	}

	// Método para insertar registros en una tabla (a implementar)
	public function insertaTabla($tabla, $valores)
	{
		// Aquí se implementará la lógica para insertar registros en la tabla
	}

	// Método para actualizar registros en una tabla (a implementar)
	public function actualizaTabla($tabla, $valores)
	{
		// Aquí se implementará la lógica para actualizar registros en la tabla
	}

	// Método para eliminar registros de una tabla (a implementar)
	public function eliminaTabla($tabla, $id)
	{
		// Aquí se implementará la lógica para eliminar un registro de la tabla
	}

	// Método privado para codificar una entrada en Base64
	private function codifica($entrada)
	{
		return base64_encode($entrada); // Retorna la entrada codificada en Base64
	}

	// Método privado para decodificar una entrada en Base64
	private function decodifica($entrada)
	{
		return base64_decode($entrada); // Retorna la entrada decodificada de Base64
	}
}

// Crea una nueva instancia de la clase conexionDB
$conexion = new conexionDB(); // Instancia de la clase que establece la conexión a la base de datos

// Llama al método 'seleccionaTabla' con el argumento "empleados" y muestra el resultado
echo $conexion->seleccionaTabla("empleados"); // Ejecuta la función y muestra el JSON de la tabla 'empleados'

// Llama al método 'listadoTablas' y muestra el resultado
echo "<br><br>";
echo $conexion->listadoTablas(); // Ejecuta la función y muestra el JSON con los nombres de las tablas
?>
