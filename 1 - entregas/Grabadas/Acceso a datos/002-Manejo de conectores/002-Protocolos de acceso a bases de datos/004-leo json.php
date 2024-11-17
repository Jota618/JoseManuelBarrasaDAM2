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
	
?>


