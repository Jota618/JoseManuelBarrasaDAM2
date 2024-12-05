<?php
if (isset($_POST["usuario"])) {
	ini_set("display_errors", 1); // Muestro los errores de PHP
	ini_set("display_startup_errors", 1); // Muestro los errores de inicio
	error_reporting(E_ALL); // Quiero mostrar todos los tipos de error

	($enlace = mysqli_connect($_POST["servidor"], $_POST["usuario"], $_POST["contrasena"], $_POST["basededatos"])) or
		die("error"); // Me conecto a la base de datos

	$json = file_get_contents("004-modelodedatos.json"); // Leo el contenido del schema
	$datos = json_decode($json, true); // Lo proceso como objeto de php

	foreach ($datos as $dato) {
		// Para cada una de las tablas
		$nombredetabla = $dato["nombre"]; // Tomo el nombre de la tabla
		$cadena =
			"CREATE TABLE " .
			$nombredetabla .
			" ( 
			  Identificador INT NOT NULL AUTO_INCREMENT , "; // Creo una cadena indicando el nombre de la tabla
		foreach ($dato["columnas"] as $columna) {
			// Para cada una de las columnas
			$cadena .= $columna["nombre"] . " " . $columna["tipo"] . " "; // Añado un campo por cada elemento del array
			if ($columna["tipo"] != "TEXT") {
				// En el caso de que el campo no sea un text
				$cadena .= " (" . $columna["longitud"] . ") "; // Le añado la longitud
			}
			$cadena .= ","; // Añado una coma al final de cada campo
		}
		$cadena .= "PRIMARY KEY (Identificador) "; // Le añado una clave primaria
		$cadena .= " )  ENGINE = InnoDB"; // Le añado el tipo de motor de la base de datos
		//echo $cadena;																								// Lanzo la cadena para debug
		mysqli_query($enlace, $cadena); // Ejecuto la peticioń contra la base de datos
	}
} else {
	 ?>
<!doctype html>
<html>
	<head>
		<title>
			Instalador de bases de datos
		</title>
		<style>
			body,html{
				height:100%;padding:0px;margin:0px;
				background:url(fondo.jpg);background-size:cover;
			}
			form{
				width:300px;height:400px;background:rgba(255,255,255,0.5);
				box-sizing:border-box;padding:20px;border-radius:20px;
				position:absolute;top:50%;left:50%;margin-left:-150px;margin-top:-200px;
				text-align:center;color:white;
				backdrop-filter:blur(20px);
			}
			form input{
				width:100%;padding:10px 0px;margin:5px 0px;
				outline:none;border:none;border-bottom:1px solid white;background:none;
			}
			form input::placeholder{
				color:white;
			}
			form input[type=submit]{
				background:white;
				border-radius:20px;
				color:black;
			}
		</style>
	</head>
	<body>
		<form method="POST" action="?">
		<h1>Instalador</h1>
			<input type="text" name="usuario" placeholder="Usuario de la base de datos">
			<input type="text" name="contrasena" placeholder="Contraseña de la base de datos">
			<input type="text" name="servidor" placeholder="Servidor de la base de datos">
			<input type="text" name="basededatos" placeholder="Nombre de la base de datos">
			<input type="submit">
		</form>
	</body>
</html>

<?php
} ?>


