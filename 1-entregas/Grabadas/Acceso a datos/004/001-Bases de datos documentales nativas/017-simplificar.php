<?php

$cliente = new MongoDB\Driver\Manager("mongodb://localhost:27017");

$basededatos = $cliente->empresa; 
$coleccion = $basededatos->clientes; 

$resultado = $coleccion->find();
/*
foreach ($resultado as $documento) {
    print_r($documento);
}
*/
?>

