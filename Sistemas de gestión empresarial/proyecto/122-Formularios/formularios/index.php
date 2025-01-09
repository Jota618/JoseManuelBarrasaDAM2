<!doctype html>
<html>
	<head>
		<link rel="Stylesheet" href="estilo.css">
	</head>
	<body>
		<form method="POST" action="envia.php">
		<h1><?php echo $_GET['f']; ?></h1>
			<input type="hidden" name="token" value="<?php echo base64_encode(date('U'));?>">
			<?php
				$archivo = 'forms/'.$_GET['f'].'.json';
				$datos = file_get_contents($archivo);
				$coleccion = json_decode($datos, true);
				foreach($coleccion as $clave=>$valor){
					echo "<input 
					type='".$valor['tipo']."' 
					name='".$valor['nombre']."'
					placeholder='".$valor['valorejemplo']."'
					minlength='".$valor['min']."'
					maxlength='".$valor['max']."'
					>";
				}
			?>
			<input type="submit">
		</form>
	</body>
</html>

