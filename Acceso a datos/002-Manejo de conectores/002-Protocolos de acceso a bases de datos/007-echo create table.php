<?php

	$enlace = mysqli_connect(
	"localhost", 
	"accesoadatos", 
	"accesoadatos", 
	"accesoadatos"
	) OR die("error");

	/*mysqli_query($enlace, "
		CREATE TABLE clientes (
		Identificador INT NOT NULL AUTO_INCREMENT ,
		nombre VARCHAR(255) NOT NULL ,
		apellidos VARCHAR(255) NOT NULL ,
		PRIMARY KEY (Identificador)
		) ENGINE = InnoDB;
		");*/
	
	$json = file_get_contents("004-modelodedatos.json");
	$datos = json_decode($json, true);
	var_dump($datos);
	echo "<br><br>";
	foreach ($datos as $dato) {
	    var_dump($dato);
	    $nombredetabla = $dato['nombre'];
	    $cadena = "CREATE TABLE ".$nombredetabla." ( ";
	    $cadena .= " ) ";
	    echo $cadena;
	    echo "<br><br>";
	}
	
?>


