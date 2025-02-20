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
<header>
    <img src="tomateazul.jpg" alt="Logo de la página" style="width: 150px; height: auto;">
    <h1>Gráficas de Uso del Sistema</h1>
    <!-- Barra de navegación (opcional) -->
    <!--<nav>
        <a href="index.php" class="active">Inicio</a>
        <a href="about.php">Sobre Nosotros</a>
        <a href="contact.php">Contacto</a>
    </nav>-->
</header>
<head>
    <meta charset="UTF-8">
    <title>Gráficas de Uso</title>
    <!-- Enlace al archivo CSS externo -->
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <?php if ($loggedIn): ?>
        <div class="container">
            <h1>Gráficas Generadas</h1>
            <?php if (!empty($images)): ?>
                <div class="gallery">
                    <?php foreach ($images as $image): ?>
                        <div>
                            <img src="<?php echo $chartFolder . '/' . $image; ?>" alt="Gráfica">
                            <a href="<?php echo $chartFolder . '/' . $image; ?>" download class="download-button">Descargar Gráfica</a>
                        </div>
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
