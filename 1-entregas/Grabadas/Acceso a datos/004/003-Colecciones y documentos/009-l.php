<?php

$contrasena = "Jose Vicente";

for($i = 0;$i<strlen($contrasena);$i++){
	echo $contrasena[$i]." - ".ord($contrasena[$i])." - ".(ord($contrasena[$i])+5)." - ".chr(ord($contrasena[$i])+5)."<br>";
}

?>

