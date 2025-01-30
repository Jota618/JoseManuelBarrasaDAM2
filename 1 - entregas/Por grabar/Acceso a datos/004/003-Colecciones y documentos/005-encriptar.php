<?php

$contrasena = "Jose Vicente";
echo "La contraseña sin encriptar  es ".$contrasena."<br>";
$encriptado = base64_encode($contrasena);
echo "La contraseña encriptada es ".$encriptado."<br>";
$desencriptado = base64_decode($encriptado);
echo "La contraseña desencriptada es ".$desencriptado."<br>";

?>

