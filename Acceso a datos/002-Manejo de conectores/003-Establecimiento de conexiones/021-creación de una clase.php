<?php
	class conexionDB{
		
			public $servidor;
			public $usuario;
			public $contrasena;
			public $basededatos;
			
			public function __construct() {
        $this->servidor = "localhost";
        $this->usuario = "accesoadatos";
        $this->contrasena = "accesoadatos";
        $this->basededatos = "accesoadatos";
        
        $mysqli = mysqli_connect(
					$this->servidor, 
					$this->usuario, 
					$this->contrasena, 
					$this->basededatos
				);
    }
			public function seleccionaTabla($tabla){
				$query = "SELECT * FROM ".$tabla.";";
				$result = mysqli_query($mysqli, $query);
				$resultado = [];
				while ($row = mysqli_fetch_assoc($result)) {
						$resultado[] = $row;
				}
				$json = json_encode($resultado, JSON_PRETTY_PRINT);
				return $json;
			}
	}
	
	
?>
