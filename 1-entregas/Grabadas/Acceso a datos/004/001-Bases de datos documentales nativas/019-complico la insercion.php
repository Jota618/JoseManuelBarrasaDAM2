<?php

$manager = new MongoDB\Driver\Manager("mongodb://localhost:27017");

$namespace = "empresa.clientes";

$bulk = new MongoDB\Driver\BulkWrite;

$documento = [
    'nombre' => 'Juan Pérez',
    'email' => ['juan.perez@example.com','correo2@empresa.com'],
    'edad' => 30
];

$bulk->insert($documento);

$manager->executeBulkWrite($namespace, $bulk);

$query = new MongoDB\Driver\Query([]);
$cursor = $manager->executeQuery($namespace, $query);


foreach ($cursor as $document) {
    print_r($document);
}

?>

