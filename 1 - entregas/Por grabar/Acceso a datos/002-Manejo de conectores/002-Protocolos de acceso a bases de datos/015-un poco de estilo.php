<?php
// Verifica si se ha enviado el formulario
if (isset($_POST["usuario"])) {
	// Configuración para mostrar errores en pantalla
	ini_set("display_errors", 1); // Activa la visualización de errores
	ini_set("display_startup_errors", 1); // Muestra errores que ocurren durante el inicio
	error_reporting(E_ALL); // Reporta todos los tipos de errores

	// Establecimiento de conexión a la base de datos MySQL utilizando los datos del formulario
	($enlace = mysqli_connect($_POST["servidor"], $_POST["usuario"], $_POST["contrasena"], $_POST["basededatos"])) or
		die("error"); // Intenta conectar a la base de datos. Si falla, se detiene la ejecución y muestra "error"

	// Lectura del archivo JSON que contiene la definición de las tablas
	$json = file_get_contents("004-modelodedatos.json"); // Lee el contenido del archivo JSON
	$datos = json_decode($json, true); // Decodifica el JSON en un array asociativo

	// Iteración sobre cada tabla definida en el JSON
	foreach ($datos as $dato) {
		// Para cada una de las tablas
		$nombredetabla = $dato["nombre"]; // Obtiene el nombre de la tabla
		// Inicia la cadena SQL para crear la tabla
		$cadena = "CREATE TABLE " . $nombredetabla . " ( Identificador INT NOT NULL AUTO_INCREMENT , ";

		// Iteración sobre las columnas definidas para la tabla
		foreach ($dato["columnas"] as $columna) {
			// Para cada una de las columnas
			// Agrega la definición de la columna a la cadena SQL
			$cadena .= $columna["nombre"] . " " . $columna["tipo"] . " "; // Define el nombre y tipo de la columna
			// Si el tipo de columna no es TEXT, se agrega la longitud
			if ($columna["tipo"] != "TEXT") {
				// En el caso de que el campo no sea un text
				$cadena .= " (" . $columna["longitud"] . ") "; // Añade la longitud de la columna
			}
			$cadena .= ","; // Agrega una coma al final de la definición de la columna
		}

		// Finaliza la cadena SQL con la clave primaria
		$cadena .= "PRIMARY KEY (Identificador) "; // Define la clave primaria
		$cadena .= " )  ENGINE = InnoDB"; // Especifica el motor de almacenamiento para la tabla

		// Ejecuta la consulta SQL para crear la tabla en la base de datos
		mysqli_query($enlace, $cadena); // Ejecuta la consulta para crear la tabla
	}
} else {
	// Si no se ha enviado el formulario, se muestra el formulario HTML
	?>
<!doctype html>
<html>
    <head>
        <title>
            Instalador de bases de datos
        </title>
        <style>
            /* Estilos para el cuerpo y el fondo de la página */
            body, html { /* Establece altura y elimina padding y margen */
                height: 100%; 
                padding: 0px; 
                margin: 0px;
                background: url(fondo.jpg); /* Establece una imagen de fondo */
                background-size: cover; /* Asegura que la imagen cubra toda la pantalla */
            }
            /* Estilos para el formulario */
            form { /* Define el estilo del formulario */
                width: 300px; 
                height: 400px; 
                background: rgba(255, 255, 255, 0.5); /* Fondo semitransparente */
                box-sizing: border-box; 
                padding: 20px; 
                border-radius: 20px; /* Bordes redondeados */
                position: absolute; 
                top: 50%; 
                left: 50%; 
                margin-left: -150px; 
                margin-top: -200px; /* Centra el formulario en la pantalla */
                text-align: center; 
                color: white; /* Color del texto */
                backdrop-filter: blur(20px); /* Efecto de desenfoque en el fondo */
            }
            /* Estilos para los campos de entrada del formulario */
            form input { /* Define el estilo de los campos de entrada */
                width: 100%; 
                padding: 10px 0px; 
                margin: 5px 0px; 
                outline: none; 
                border: none; 
                border-bottom:  1px solid white; /* Línea inferior blanca */
                background: none; /* Sin fondo */
            }
            /* Estilos para los placeholders de los campos de entrada */
            form input::placeholder { /* Define el estilo de los placeholders */
                color: white; /* Color del texto de los placeholders */
            }
            /* Estilos para el botón de envío */
            form input[type=submit] { /* Define el estilo del botón de envío */
                background: white; /* Fondo blanco */
                border-radius: 20px; /* Bordes redondeados */
                color: black; /* Color del texto */
            }
        </style>
    </head>
    <body>
        <!-- Formulario para ingresar los datos de conexión a la base de datos -->
        <form method="POST" action="?">
            <h1>Instalador</h1>
            <input type="text" name="usuario" placeholder="Usuario de la base de datos"> <!-- Campo de texto para el usuario -->
            <input type="text" name="contrasena" placeholder="Contraseña de la base de datos"> <!-- Campo de texto para la contraseña -->
            <input type="text" name="servidor" placeholder="Servidor de la base de datos"> <!-- Campo de texto para el servidor -->
            <input type="text" name="basededatos" placeholder="Nombre de la base de datos"> <!-- Campo de texto para el nombre de la base de datos -->
            <input type="submit"> <!-- Botón de envío -->
        </form>
    </body>
</html>

<?php
} ?>
