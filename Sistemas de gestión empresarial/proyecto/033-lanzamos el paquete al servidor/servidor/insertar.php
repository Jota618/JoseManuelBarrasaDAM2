<?php
    echo "Hola desde PHP\n";
    echo "Vamos a ver si nos llega la información:";
    
    $json = file_get_contents('php://input');
    
    $data = json_decode($json, true);
    
    if ($data) {
        foreach($data as $clave=>$valor){
            echo "El campo: ".$clave." me ha traido el valor ".$valor."<br>";
        }
    } else {
        echo "No se pudo decodificar el JSON.\n";
    }
?>

