<?php
session_start();

// Credenciales de acceso
$VALID_USERNAME = 'jota';
$VALID_PASSWORD = 'jota';

// Logout
if (isset($_GET['action']) && $_GET['action'] === 'logout') {
    session_unset();
    session_destroy();
    header("Location: index.php");
    exit;
}

// Manejo del login
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['login'])) {
    $username = $_POST['username'] ?? '';
    $password = $_POST['password'] ?? '';
    if ($username === $VALID_USERNAME && $password === $VALID_PASSWORD) {
        $_SESSION['loggedin'] = true;
        $_SESSION['username'] = $username;
        header("Location: index.php");
        exit;
    } else {
        $error = "Usuario o contraseña inválidos.";
    }
}

$loggedIn = $_SESSION['loggedin'] ?? false;

// Obtener imágenes de una carpeta
function getImages($folder) {
    $images = [];
    if (is_dir($folder)) {
        $files = array_diff(scandir($folder), array('.', '..'));
        foreach ($files as $file) {
            if (preg_match('/\.(jpg|jpeg|png|gif)$/i', $file)) {
                $images[] = $file;
            }
        }
    }
    return $images;
}

// Carpeta de imágenes (ruta local en XAMPP)
$chartFolder = 'img/hourly';
$images = $loggedIn ? getImages($chartFolder) : [];
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gráficas de Uso</title>
    <style>
        /* Estilos generales */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            flex-direction: column;
        }

        /* Estilo del contenedor principal */
        .container {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
            width: 90%;
            max-width: 600px;
        }

        /* Estilos del formulario de login */
        .login-form {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .login-form input {
            padding: 10px;
            font-size: 1rem;
            border: 1px solid #ddd;
            border-radius: 5px;
            width: 100%;
        }

        .login-form button {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px;
            font-size: 1rem;
            border-radius: 5px;
            cursor: pointer;
            transition: 0.3s;
        }

        .login-form button:hover {
            background-color: #218838;
        }

        .error {
            color: red;
            font-size: 0.9rem;
            margin-bottom: 10px;
        }

        /* Botón de logout */
        .logout-button {
            display: inline-block;
            padding: 10px 15px;
            background-color: #dc3545;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 20px;
            transition: 0.3s;
        }

        .logout-button:hover {
            background-color: #c82333;
        }

        /* Galería de imágenes */
        .gallery {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }

        .gallery img {
            width: 100%;
            border-radius: 5px;
            transition: transform 0.3s;
            cursor: pointer;
        }

        .gallery img:hover {
            transform: scale(1.05);
        }

        /* Mensaje cuando no hay imágenes */
        .no-images {
            color: #555;
            font-size: 1rem;
            margin-top: 10px;
        }
    </style>
</head>
<body>

    <?php if ($loggedIn): ?>
        <div class="container">
            <h1>Gráficas Generadas</h1>
            <?php if (!empty($images)): ?>
                <div class="gallery">
                    <?php foreach ($images as $image): ?>
                        <img src="<?php echo $chartFolder . '/' . $image; ?>" alt="Gráfica">
                    <?php endforeach; ?>
                </div>
            <?php else: ?>
                <p class="no-images">No hay gráficas disponibles.</p>
            <?php endif; ?>
            <a href="index.php?action=logout" class="logout-button">Cerrar sesión</a>
        </div>
    <?php else: ?>
        <div class="container">
            <h2>Iniciar Sesión</h2>
            <?php if (isset($error)): ?>
                <p class="error"><?php echo htmlspecialchars($error); ?></p>
            <?php endif; ?>
            <form class="login-form" action="index.php" method="post">
                <input type="text" name="username" placeholder="Usuario" required>
                <input type="password" name="password" placeholder="Contraseña" required>
                <button type="submit" name="login">Ingresar</button>
            </form>
        </div>
    <?php endif; ?>

</body>
</html>
