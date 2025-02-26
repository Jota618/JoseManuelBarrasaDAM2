<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Control XML</title>
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

        .carpeta {
            margin-bottom: 20px;
            padding: 10px;
            border: 1px solid #ddd;
            background-color: #fff;
            border-radius: 5px;
        }

        .carpeta h2 {
            margin-bottom: 10px;
            color: #007bff;
        }

        .lista-archivos {
            list-style-type: none;
            padding: 0;
        }

        .lista-archivos li {
            padding: 5px 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #eee;
        }

        .lista-archivos li:last-child {
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

        /* Estilos del Modal */
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

        .contenido-modal {
            background: #fff;
            padding: 20px;
            border-radius: 5px;
            width: 80%;
            max-height: 80%;
            overflow-y: auto;
        }

        .contenido-modal pre {
            font-family: monospace;
            background-color: #f9f9f9;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        .boton-cerrar {
            display: block;
            margin-left: auto;
            margin-right: 0;
            background-color: #dc3545;
            padding: 5px 10px;
        }

        .boton-cerrar:hover {
            background-color: #a71d2a;
        }
    </style>
</head>
<body>
    <h1>Panel de Control XML</h1>

    <?php
    function analizarDirectorio($directorioBase)
    {
        $elementos = scandir($directorioBase);
        foreach ($elementos as $elemento) {
            if ($elemento === '.' || $elemento === '..') {
                continue;
            }

            $rutaCompleta = $directorioBase . '/' . $elemento;

            if (is_dir($rutaCompleta)) {
                echo "<div class='carpeta'>";
                echo "<h2>Carpeta: $elemento</h2>";
                echo "<ul class='lista-archivos'>";
                analizarDirectorio($rutaCompleta); // Llamada recursiva para subdirectorios
                echo "</ul>";
                echo "</div>";
            } elseif (pathinfo($rutaCompleta, PATHINFO_EXTENSION) === 'xml') {
                echo "<li>
                        $elemento 
                        <button onclick=\"verContenido('$rutaCompleta')\">Ver</button>
                      </li>";
            }
        }
    }

    $directorioBase = 'xml';
    if (!is_dir($directorioBase)) {
        echo "<p>El directorio base de XML no existe.</p>";
        exit;
    }

    echo "<ul class='lista-archivos'>";
    analizarDirectorio($directorioBase);
    echo "</ul>";
    ?>

    <!-- Modal -->
    <div id="modalContenido" class="modal">
        <div class="contenido-modal">
            <button class="boton-cerrar" onclick="cerrarModal()">Cerrar</button>
            <pre id="visorContenido"></pre>
        </div>
    </div>

    <script>
        function verContenido(rutaArchivo) {
            fetch(rutaArchivo)
                .then(response => {
                    if (!response.ok) throw new Error('Error al obtener el contenido del archivo.');
                    return response.text();
                })
                .then(contenido => {
                    document.getElementById('visorContenido').textContent = contenido;
                    document.getElementById('modalContenido').style.display = 'flex';
                })
                .catch(error => {
                    alert('Error al cargar el contenido del archivo: ' + error.message);
                });
        }

        function cerrarModal() {
            document.getElementById('modalContenido').style.display = 'none';
        }
    </script>
</body>
</html>