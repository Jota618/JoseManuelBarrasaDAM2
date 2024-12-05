<?php
	ini_set('display_errors', 1);																								// Activo errores
	ini_set('display_startup_errors', 1);																		// Activo errores de inicio
	error_reporting(E_ALL);																											// 
	
	class conexionDB{																													// Creo una nueva clase
		
			private $servidor;																										// creo una serie de propiedades privadas
			private $usuario;																											// 
			private $contrasena;																									// 
			private $basededatos;																									// 
			private $conexion;																										// 
			
			public function __construct() {																				// Creo un constructor
        $this->servidor = "localhost";																			// Le doy los datos de acceso a la base de datos
        $this->usuario = "accesoadatos";																		// 
        $this->contrasena = "accesoadatos";																	// 
        $this->basededatos = "accesoadatos";																// 
        
        $this->conexion = mysqli_connect(
					$this->servidor, 
					$this->usuario, 
					$this->contrasena, 
					$this->basededatos
				);																															// Establezco una conexión con la base de datos
    }
			public function seleccionaTabla($tabla){													// Creo un metodo de seleccion
				$query = "SELECT * FROM ".$tabla.";";														// Creo la petición dinámica
				$result = mysqli_query($this->conexion , $query);								// Ejecuto la peticion
				$resultado = [];																								// Creo un array vacio
				while ($row = mysqli_fetch_assoc($result)) {										// PAra cada uno de los registros
						//$resultado[] = $row;																			// Los añado al array
						$fila = [];
						foreach($row as $clave=>$valor){
							$fila[$clave] = $valor;
						}
						$resultado[] = $fila;
				}
				$json = json_encode($resultado, JSON_PRETTY_PRINT);							// Lo codifico como json
				return $json;																										// Devuelvo el json
			}
			
			public function listadoTablas(){
				$query = "SHOW TABLES;";																				// Creo la petición dinámica
				$result = mysqli_query($this->conexion , $query);								// Ejecuto la peticion
				$resultado = [];																								// Creo un array vacio
				while ($row = mysqli_fetch_assoc($result)) {										// PAra cada uno de los registros
						//$resultado[] = $row;																			// Los añado al array
						$fila = [];
						foreach($row as $clave=>$valor){
							$fila[$clave] = $valor;
						}
						$resultado[] = $fila;
				}
				$json = json_encode($resultado, JSON_PRETTY_PRINT);							// Lo codifico como json
				return $json;																										// Devuelvo el json
			}
			
			public function insertaTabla($tabla,$valores){										// Método de inserción de nuevos registros
					$campos = "";																									// Creo un string para guardar los campos
					$datos = ""; 																									// Creo un string para guardar los datos
					foreach($valores as $clave=>$valor){													// Para cada uno de los datos
						$campos .= $clave.",";																			// Añado el nombre del campo al string
						$datos .= "'".$valor."',";																	// Añado del dato al string
					}
					$campos = substr($campos, 0, -1);															// Le quito la ultima coma al string
					$datos = substr($datos, 0, -1);																// Le quito la ultima coma al string
					$query = "
						INSERT INTO ".$tabla." 
						(".$campos.") 
						VALUES (".$datos.");
						";																													// preparo la petición de inserción
					$result = mysqli_query($this->conexion , $query);							// Ejecuto la peticion
					return 0;																											// return 0
			}
			
			public function actualizaTabla($tabla,$valores,$id){
					$query = "
						UPDATE ".$tabla." 
						SET
						";																													// Empiezo a formatear la query de actualización
					foreach($valores as $clave=>$valor){													// Para cada uno de los datos
						$query .= $clave."='".$valor."', ";													// Encadeno con la query
					}
					$query = substr($query, 0, -2);																// Le quito los dos ultimos caracteres
						$query .= "
						WHERE Identificador = ".$id."
						";																													// preparo la petición de inserción
					echo $query;
					$result = mysqli_query($this->conexion , $query);							// Ejecuto la peticion
					return "";							
			}
			public function eliminaTabla($tabla,$id){
				$query = "
						DELETE FROM ".$tabla." 
						WHERE Identificador = ".$id.";
						";	
				$result = mysqli_query($this->conexion , $query);							// Ejecuto la peticion
			}
			
			private function codifica($entrada){
				return base64_encode($entrada);
			}
			
			private function decodifica($entrada){
				return base64_decode($entrada);
			}
	}
	
	$conexion = new conexionDB();												//
	
	/*echo $conexion->seleccionaTabla("empleados");	
	echo "<br><br>";
	echo $conexion->listadoTablas();		//*/
	
	echo $conexion->eliminaTabla(
		"clientes",
		'4'
		);
	
?>
