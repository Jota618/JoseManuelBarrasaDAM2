<?php
// Ensure errors are displayed during development
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

var_dump($_POST);

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get the raw POST data
    $rawData = file_get_contents('php://input');
    $parsedData = json_decode($rawData, true);

    // Ensure data is valid
    if (json_last_error() !== JSON_ERROR_NONE || !is_array($parsedData)) {
        http_response_code(400);
        echo json_encode(['error' => 'Invalid JSON data']);
        exit;
    }

    // Create the XML structure
    $xml = new SimpleXMLElement('<root/>');

    // Recursively add data to the XML
    function arrayToXml(array $data, SimpleXMLElement &$xml) {
        foreach ($data as $key => $value) {
            if (is_array($value)) {
                $subNode = $xml->addChild(is_numeric($key) ? "item$key" : $key);
                arrayToXml($value, $subNode);
            } else {
                $xml->addChild(is_numeric($key) ? "item$key" : $key, htmlspecialchars($value));
            }
        }
    }
    arrayToXml($parsedData, $xml);

    // Convert SimpleXMLElement to a pretty printed XML string
    $dom = new DOMDocument('1.0', 'UTF-8');
    $dom->preserveWhiteSpace = false;
    $dom->formatOutput = true;
    $dom->loadXML($xml->asXML());
    $prettyXml = $dom->saveXML();

    // Generate the filename with the current epoch time
    $filename = 'xml/'.$_GET['f'].'/' . date('U') . '.xml';

    // Save the pretty printed XML to a file
    if (file_put_contents($filename, $prettyXml)) {
        http_response_code(200);
        echo json_encode(['success' => true, 'message' => 'Data saved to XML', 'file' => $filename]);
    } else {
        http_response_code(500);
        echo json_encode(['error' => 'Failed to save XML']);
    }
} else {
    // Handle invalid request method
    http_response_code(405);
    echo json_encode(['error' => 'Invalid request method. Use POST.']);
}

