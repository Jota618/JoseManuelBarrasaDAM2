
<?php
function parseFolderAndFiles($folderPath) {
    if (!is_dir($folderPath)) {
        die("The folder does not exist: $folderPath");
    }

    // Helper function to recursively scan folders
    function scanDirRecursively($path) {
        $items = scandir($path);
        foreach ($items as $item) {
            // Skip current and parent directory pointers
            if ($item === '.' || $item === '..') {
                continue;
            }

            $fullPath = $path . DIRECTORY_SEPARATOR . $item;
            if (is_dir($fullPath)) {
                echo "<h3>" . $item . PHP_EOL . "</h3>";
                scanDirRecursively($fullPath); // Recursive call
            } elseif (is_file($fullPath)) {
                echo "<strong>" . $item . PHP_EOL. "</strong><br>";

                $content = file_get_contents($fullPath);
                echo "<p>" . nl2br($content) .  PHP_EOL . "</p>"; 
            }
        }
    }

    // Start scanning from the root folder
    scanDirRecursively($folderPath);
}

// Example usage
$folderPath = 'materiales';
parseFolderAndFiles($folderPath);
?>

