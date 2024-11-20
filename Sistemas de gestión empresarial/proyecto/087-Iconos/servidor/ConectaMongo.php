<?php

	class ConectaMongo{
			private $servidor;																										// creo una serie de propiedades privadas																								// 
			private $basededatos;																									// 
			private $conexion;	
			
			public function __construct() {																				// Creo un constructor
				  $this->servidor = "mongodb://localhost:27017";																			// Le doy los datos de acceso a la base de datos  
				  $this->basededatos = "crimson";																// 	  
				  $this->conexion = new MongoDB\Driver\Manager($this->servidor);																														// Establezco una conexión con la base de datos
			 }
			 
			 public function listar($coleccion){
				$query = new MongoDB\Driver\Query([]);
				$namespace = $this->basededatos.".".$coleccion;
				$cursor = $this->conexion->executeQuery($namespace, $query);
				$resultado = [];
				foreach ($cursor as $document) {
					 $resultado[] = $document;
				}
				$json = json_encode($resultado, JSON_PRETTY_PRINT);
				return $json;	
			}
			
			public function insertar($coleccion,$datos){
				$namespace = $this->basededatos.".".$coleccion;
				$bulk = new MongoDB\Driver\BulkWrite;
				$bulk->insert($datos);
				$this->conexion->executeBulkWrite($namespace, $bulk);
				$query = new MongoDB\Driver\Query([]);
				$cursor = $this->conexion->executeQuery($namespace, $query);
				
				return 0;	
			}
			public function listarColecciones() {
				$command = new MongoDB\Driver\Command(["listCollections" => 1]);
				$cursor = $this->conexion->executeCommand($this->basededatos, $command);
				$colecciones = [];
				$nombreClave = "Tables_in_" . $this->basededatos;

				foreach ($cursor as $collection) {
					$fila = [
						$nombreClave => $collection->name,
						"Comentario" => ""  // Placeholder for comment, since MongoDB doesn't have table comments
					];
					$colecciones[] = $fila;
				}

				$json = json_encode($colecciones, JSON_PRETTY_PRINT);
				return $json;
			}
	}



?>
