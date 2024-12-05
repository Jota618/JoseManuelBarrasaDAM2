<?php
	ini_set('display_errors', 1);												// Activo errores
	ini_set('display_startup_errors', 1);								// Activo errores de inicio
	error_reporting(E_ALL);															// 
	
	class conexionDB{																		// Creo una nueva clase
		
			private $servidor;															// creo una serie de propiedades privadas
			private $usuario;																// 
			private $contrasena;														// 
			private $basededatos;														// 
			private $conexion;															// 
			
			public function __construct() {									// Creo un constructor
        $this->servidor = "localhost";								// Le doy los datos de acceso a la base de datos
        $this->usuario = "accesoadatos";							// 
        $this->contrasena = "accesoadatos";						// 
        $this->basededatos = "accesoadatos";					// 
        
        $this->conexion = mysqli_connect(
					$this->servidor, 
					$this->usuario, 
					$this->contrasena, 
					$this->basededatos
				);																						// Establezco una conexión con la base de datos
    }
			public function seleccionaTabla($tabla){				// Creo un metodo de seleccion
				$query = "SELECT * FROM ".$tabla.";";					// Creo la petición dinámica
				$result = mysqli_query($this->conexion , $query);		// Ejecuto la peticion
				$resultado = [];															// Creo un array vacio
				while ($row = mysqli_fetch_assoc($result)) {	// PAra cada uno de los registros
						$resultado[] = $row;											// Los añado al array
				}
				$json = json_encode($resultado, JSON_PRETTY_PRINT);		// Lo codifico como json
				return $json;																	// Devuelvo el json
			}
	}
	
	$conexion = new conexionDB();												//
	
	echo $conexion->seleccionaTabla("empleados");												//
	
?>
