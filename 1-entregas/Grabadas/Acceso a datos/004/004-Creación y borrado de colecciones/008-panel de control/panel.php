<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>XML Control Panel</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            color: #333;
            margin: 0;
            padding: 20px;
        }

        h1 {
            text-align: center;
            color: #0056b3;
        }

        .folder {
            margin-bottom: 20px;
            padding: 10px;
            border: 1px solid #ddd;
            background-color: #fff;
            border-radius: 5px;
        }

        .folder h2 {
            margin-bottom: 10px;
            color: #007bff;
        }

        .file-list {
            list-style-type: none;
            padding: 0;
        }

        .file-list li {
            padding: 5px 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #eee;
        }

        .file-list li:last-child {
            border-bottom: none;
        }

        button {
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 5px;
            padding: 5px 10px;
            cursor: pointer;
            font-size: 14px;
        }

        button:hover {
            background-color: #0056b3;
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        .modal-content {
            background: #fff;
            padding: 20px;
            border-radius: 5px;
            width: 80%;
            max-height: 80%;
            overflow-y: auto;
        }

        .modal-content pre {
            font-family: monospace;
            background-color: #f9f9f9;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        .close-btn {
            display: block;
            margin-left: auto;
            margin-right: 0;
            background-color: #dc3545;
            padding: 5px 10px;
        }

        .close-btn:hover {
            background-color: #a71d2a;
        }
    </style>
</head>
<body>
    <h1>XML Control Panel</h1>

    <?php
    function parseDirectory($baseDir)
    {
        $items = scandir($baseDir);
        foreach ($items as $item) {
            if ($item === '.' || $item === '..') {
                continue;
            }

            $fullPath = $baseDir . '/' . $item;

            if (is_dir($fullPath)) {
                echo "<div class='folder'>";
                echo "<h2>Folder: $item</h2>";
                echo "<ul class='file-list'>";
                parseDirectory($fullPath); // Recursive call for subdirectories
                echo "</ul>";
                echo "</div>";
            } elseif (pathinfo($fullPath, PATHINFO_EXTENSION) === 'xml') {
                echo "<li>
                        $item 
                        <button onclick=\"viewContent('$fullPath')\">View</button>
                      </li>";
            }
        }
    }

    $baseDir = 'xml';
    if (!is_dir($baseDir)) {
        echo "<p>XML base directory does not exist.</p>";
        exit;
    }

    echo "<ul class='file-list'>";
    parseDirectory($baseDir);
    echo "</ul>";
    ?>

    <!-- Modal -->
    <div id="contentModal" class="modal">
        <div class="modal-content">
            <button class="close-btn" onclick="closeModal()">Close</button>
            <pre id="contentViewer"></pre>
        </div>
    </div>

    <script>
        function viewContent(filePath) {
            fetch(filePath)
                .then(response => {
                    if (!response.ok) throw new Error('Failed to fetch file content.');
                    return response.text();
                })
                .then(content => {
                    const viewer = document.getElementById('contentViewer');
                    viewer.textContent = content;
                    const modal = document.getElementById('contentModal');
                    modal.style.display = 'flex';
                })
                .catch(error => {
                    alert('Error loading file content: ' + error.message);
                });
        }

        function closeModal() {
            const modal = document.getElementById('contentModal');
            modal.style.display = 'none';
        }
    </script>
</body>
</html>

