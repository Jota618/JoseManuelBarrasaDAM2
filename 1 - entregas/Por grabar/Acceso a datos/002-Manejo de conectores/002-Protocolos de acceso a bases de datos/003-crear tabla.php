<?php

($enlace = mysqli_connect("localhost", "accesoadatos", "accesoadatos", "accesoadatos")) or die("error");

//En caso de que la tabla ya exista, dara error
mysqli_query(
	$enlace,
	"
		CREATE TABLE clientes (
		Identificador INT NOT NULL AUTO_INCREMENT ,
		nombre VARCHAR(255) NOT NULL ,
		apellidos VARCHAR(255) NOT NULL ,
		PRIMARY KEY (Identificador)
		) ENGINE = InnoDB;
		"
);
?>