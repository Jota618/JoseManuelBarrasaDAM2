<?php
// Mostrar errores durante el desarrollo
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

var_dump($_POST);

// Verificar si el método de solicitud es POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Obtener los datos crudos del POST
    $datosCrudos = file_get_contents('php://input');
    $datosDecodificados = json_decode($datosCrudos, true);

    // Verificar que los datos sean válidos
    if (json_last_error() !== JSON_ERROR_NONE || !is_array($datosDecodificados)) {
        http_response_code(400);
        echo json_encode(['error' => 'Datos JSON no válidos']);
        exit;
    }

    // Crear la estructura XML
    $xml = new SimpleXMLElement('<raiz/>');

    // Función para agregar datos recursivamente al XML
    function arrayAXml(array $datos, SimpleXMLElement &$xml) {
        foreach ($datos as $clave => $valor) {
            if (is_array($valor)) {
                $subNodo = $xml->addChild(is_numeric($clave) ? "item$clave" : $clave);
                arrayAXml($valor, $subNodo);
            } else {
                $xml->addChild(is_numeric($clave) ? "item$clave" : $clave, htmlspecialchars($valor));
            }
        }
    }
    arrayAXml($datosDecodificados, $xml);

    // Convertir el XML a una cadena formateada
    $dom = new DOMDocument('1.0', 'UTF-8');
    $dom->preserveWhiteSpace = false;
    $dom->formatOutput = true;
    $dom->loadXML($xml->asXML());
    $xmlFormateado = $dom->saveXML();

    // Generar el nombre del archivo con la marca de tiempo actual
    $nombreArchivo = 'xml/' . $_GET['f'] . '/' . date('U') . '.xml';

    // Guardar el XML en un archivo
    if (file_put_contents($nombreArchivo, $xmlFormateado)) {
        http_response_code(200);
        echo json_encode(['exito' => true, 'mensaje' => 'Datos guardados en XML', 'archivo' => $nombreArchivo]);
    } else {
        http_response_code(500);
        echo json_encode(['error' => 'Error al guardar el XML']);
    }
} else {
    // Manejar método de solicitud inválido
    http_response_code(405);
    echo json_encode(['error' => 'Método de solicitud no válido. Use POST.']);
}
