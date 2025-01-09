<?php

$contrasena = "Jose Vicente";

function codifica($entrada){
	for($i = 0;$i<strlen($entrada);$i++){
		$entrada[$i] = chr(ord($entrada[$i])+5);
	}
	$entrada = base64_encode(base64_encode(base64_encode($entrada)));
	return $entrada;
}

function descodifica($entrada){
	$entrada = base64_decode(base64_decode(base64_decode($entrada)));
	//echo $entrada;
	for($i = 0;$i<strlen($entrada);$i++){
		$entrada[$i] = chr(ord($entrada[$i])-5);
	}
	return $entrada;
}
echo "La contraseña es: ".$contrasena."<br>";
$codificado = codifica($contrasena);
echo "La contraseña es: ".$codificado."<br>";
$descodificado = descodifica($codificado);
echo "La contraseña es: ".$descodificado."<br>";

?>

