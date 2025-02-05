<?php

$manager = new MongoDB\Driver\Manager("mongodb://localhost:27017");

$query = new MongoDB\Driver\Query([]);

$namespace = "empresa.clientes";

$cursor = $manager->executeQuery($namespace, $query);

foreach ($cursor as $document) {
    print_r($document);
}
?>

