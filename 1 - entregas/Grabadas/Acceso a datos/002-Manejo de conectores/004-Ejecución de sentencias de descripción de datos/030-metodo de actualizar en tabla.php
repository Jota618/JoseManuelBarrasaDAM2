<?php
ini_set("display_errors", 1); // Activa la visualización de errores en la página
ini_set("display_startup_errors", 1); // Activa la visualización de errores en el inicio del servidor
error_reporting(E_ALL); // Configura el nivel de reporte de errores para mostrar todos los tipos de errores

class conexionDB // Definición de la clase conexionDB que manejará la conexión a la base de datos
{
	private $servidor; // Propiedad privada para almacenar el nombre del servidor
	private $usuario; // Propiedad privada para el nombre de usuario de la base de datos
	private $contrasena; // Propiedad privada para la contraseña del usuario
	private $basededatos; // Propiedad privada para el nombre de la base de datos a la que se conectará
	private $conexion; // Propiedad privada que almacenará la conexión a la base de datos

	public function __construct()
	{
		// Constructor de la clase, ejecutado al crear un objeto de conexionDB
		$this->servidor = "localhost"; // Asigna el servidor de la base de datos (localhost en este caso)
		$this->usuario = "accesoadatos"; // Asigna el nombre de usuario
		$this->contrasena = "accesoadatos"; // Asigna la contraseña
		$this->basededatos = "accesoadatos"; // Asigna el nombre de la base de datos

		// Establece una conexión a la base de datos usando mysqli_connect
		$this->conexion = mysqli_connect($this->servidor, $this->usuario, $this->contrasena, $this->basededatos);
	}

	public function seleccionaTabla($tabla)
	{
		// Método para seleccionar todos los registros de una tabla
		$query = "SELECT * FROM " . $tabla . ";"; // Construye la consulta SQL para seleccionar todos los registros de la tabla
		$result = mysqli_query($this->conexion, $query); // Ejecuta la consulta SQL en la conexión actual
		$resultado = []; // Inicializa un array vacío para almacenar los resultados

		// Itera sobre los resultados obtenidos de la consulta
		while ($row = mysqli_fetch_assoc($result)) {
			$fila = []; // Inicializa un array vacío para cada fila de resultados
			foreach ($row as $clave => $valor) {
				// Recorre cada columna del registro
				$fila[$clave] = $valor; // Almacena cada valor en el array de la fila
			}
			$resultado[] = $fila; // Añade la fila al array de resultados
		}

		// Codifica los resultados como un JSON con formato legible
		$json = json_encode($resultado, JSON_PRETTY_PRINT);
		return $json; // Devuelve el resultado en formato JSON
	}

	public function listadoTablas()
	{
		// Método para obtener el listado de tablas en la base de datos
		$query = "SHOW TABLES;"; // Consulta SQL para mostrar las tablas de la base de datos
		$result = mysqli_query($this->conexion, $query); // Ejecuta la consulta
		$resultado = []; // Inicializa un array vacío para almacenar los nombres de las tablas

		// Itera sobre los resultados de la consulta
		while ($row = mysqli_fetch_assoc($result)) {
			$fila = []; // Inicializa un array vacío para cada fila de resultados
			foreach ($row as $clave => $valor) {
				// Recorre cada columna del registro
				$fila[$clave] = $valor; // Almacena cada valor en el array de la fila
			}
			$resultado[] = $fila; // Añade la fila al array de resultados
		}

		// Codifica los resultados como un JSON con formato legible
		$json = json_encode($resultado, JSON_PRETTY_PRINT);
		return $json; // Devuelve el resultado en formato JSON
	}

	public function insertaTabla($tabla, $valores)
	{
		// Método para insertar nuevos registros en una tabla
		$campos = ""; // String para almacenar los nombres de los campos
		$datos = ""; // String para almacenar los valores correspondientes

		// Recorre el array asociativo de valores
		foreach ($valores as $clave => $valor) {
			$campos .= $clave . ","; // Añade el nombre del campo al string
			$datos .= "'" . $valor . "',"; // Añade el valor al string, con comillas simples
		}

		// Elimina la última coma sobrante de los strings de campos y datos
		$campos = substr($campos, 0, -1);
		$datos = substr($datos, 0, -1);

		// Construye la consulta SQL para insertar el nuevo registro
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
		$result = mysqli_query($this->conexion, $query); // Ejecuta la consulta de inserción
		return 0; // Retorna 0 indicando que la operación fue exitosa
	}

	public function actualizaTabla($tabla, $valores, $id)
	{
		// Método para actualizar registros en una tabla
		$query =
			"
                UPDATE " .
			$tabla .
			" 
                SET
            "; // Inicia la construcción de la consulta SQL de actualización

		// Recorre el array asociativo de valores para actualizar
		foreach ($valores as $clave => $valor) {
			$query .= $clave . "='" . $valor . "', "; // Añade cada campo y su nuevo valor a la consulta
		}

		// Elimina los últimos dos caracteres sobrantes de la consulta
		$query = substr($query, 0, -2);
		// Añade la cláusula WHERE para especificar qué registro actualizar
		$query .=
			"
                WHERE Identificador = " .
			$id .
			";
            ";

		echo $query; // Muestra la consulta en pantalla (útil para depuración)
		$result = mysqli_query($this->conexion, $query); // Ejecuta la consulta de actualización
		return ""; // Retorna una cadena vacía
	}

	public function eliminaTabla($tabla, $id)
	{
		// Método para eliminar registros (pendiente de implementación)
	}

	private function codifica($entrada)
	{
		// Método privado para codificar una cadena en base64
		return base64_encode($entrada); // Devuelve la cadena codificada en base64
	}

	private function decodifica($entrada)
	{
		// Método privado para decodificar una cadena de base64
		return base64_decode($entrada); // Devuelve la cadena decodificada de base64
	}
}

// Crea una nueva instancia de la clase conexionDB
$conexion = new conexionDB();

// Ejemplo de cómo actualizar la tabla "clientes"
echo $conexion->actualizaTabla(
	"clientes", // Nombre de la tabla
	["nombre" => "Juanito", "apellidos" => "Menganito"], // Valores a actualizar
	"8" // Identificador del registro que se va a actualizar
);
?>
