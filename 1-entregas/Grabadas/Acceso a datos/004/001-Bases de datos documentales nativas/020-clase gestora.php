<?php

	class ConectaMongo{
			private $servidor;																										// creo una serie de propiedades privadas																								// 
			private $basededatos;																									// 
			private $conexion;	
			
			public function __construct() {																				// Creo un constructor
				  $this->servidor = "mongodb://localhost:27017";																			// Le doy los datos de acceso a la base de datos
				  
				  $this->basededatos = "empresa";																// 
				  
				  $this->conexion = new MongoDB\Driver\Manager($servidor);																														// Establezco una conexión con la base de datos
			 }
	}

?>
