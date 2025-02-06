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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>jota | Tomato</title>
    <link rel="icon" href="https://jocarsa.com/static/logo/tomato.png" type="image/svg+xml">
    <style>
    @import url('https://fonts.googleapis.com/css2?family=Ubuntu:wght@300;400;500;700&display=swap');

    /* Reset y estilos generales */
    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
    }
    body {
        font-family: Ubuntu, 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: #f0f2f5;
        color: #333;
        min-height: 100vh;
    }

    /* Header */
    .header {
        background-color: tomato;
        width: 100%;
        padding: 15px 30px;
        color: white;
        display: flex;
        justify-content: space-between;
        align-items: center;
        position: fixed;
        top: 0;
        left: 0;
        z-index: 100;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    .header .app-name {
        font-size: 1.5rem;
        font-weight: bold;
        display: flex;
        align-items: center;
    }
    .header .app-name img {
        width: 50px;
        margin-right: 20px;
    }
    .header .logout-button {
        background-color: tomato;
        color: white;
        border: 2px solid white;
        padding: 8px 16px;
        border-radius: 25px;
        cursor: pointer;
        text-decoration: none;
        font-size: 1rem;
        transition: background-color 0.3s, border-color 0.3s;
    }
    .header .logout-button:hover {
        background-color: darkred;
        border-color: darkred;
    }

    /* Sidebar */
    .sidebar {
        width: 250px;
        background: #fff;
        padding: 20px;
        border-right: 1px solid #ddd;
        position: fixed;
        top: 70px;
        bottom: 0;
        overflow-y: auto;
        box-shadow: 2px 0 5px rgba(0,0,0,0.05);
    }
    .sidebar h3 {
        margin-bottom: 20px;
        color: tomato;
        font-size: 1.2rem;
    }
    .sidebar a {
        display: block;
        padding: 12px 16px;
        margin: 8px 0;
        color: tomato;
        text-decoration: none;
        border-radius: 8px;
        transition: background-color 0.3s, color 0.3s;
    }
    .sidebar a:hover, .sidebar a.active {
        background-color: tomato;
        color: white;
    }

    /* Contenido principal */
    .content {
        flex: 1;
        padding: 20px;
        overflow-y: auto;
        margin-top: 70px;
        margin-left: 270px;
    }
    .dashboard {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 20px;
    }
    .image-card {
        text-align: center;
        background: #fff;
        padding: 15px;
        border-radius: 10px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        transition: transform 0.2s, box-shadow 0.2s;
    }
    .image-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 12px rgba(0, 0, 0, 0.2);
    }
    .image-card img {
        max-width: 100%;
        height: auto;
        border-radius: 10px;
    }

    /* Login */
    .login-container {
        background: #fff;
        padding: 40px 30px;
        max-width: 400px;
        width: 90%;
        margin: 100px auto;
        border-radius: 10px;
        box-shadow: 0 8px 16px rgba(0,0,0,0.1);
        text-align: center;
    }
    .login-container input {
        width: 100%;
        padding: 10px 12px;
        margin-bottom: 20px;
        border: 1px solid #ddd;
        border-radius: 5px;
        font-size: 1rem;
    }
    .login-container button {
        width: 100%;
        padding: 12px;
        background-color: tomato;
        border: none;
        color: white;
        font-size: 1rem;
        border-radius: 25px;
        cursor: pointer;
        transition: background-color 0.3s;
    }
    .login-container button:hover {
        background-color: darkred;
    }
    </style>
</head>
<body>
    <?php if ($loggedIn): ?>
        <div class="header">
            <div class="app-name"><img src="https://jocarsa.com/static/logo/tomato.png">Jota | Tomato</div>
            <a href="index.php?action=logout" class="logout-button">Cerrar Sesión</a>
        </div>

        <div class="sidebar">
            <h3>Gráficas</h3>
            <a href="index.php?type=hourly">Última Hora</a>
        </div>

        <div class="content">
            <div class="dashboard">
                <?php if (!empty($images)): ?>
                    <?php foreach ($images as $image): ?>
                        <div class="image-card">
                            <img src="<?php echo $chartFolder . '/' . $image; ?>" alt="Chart">
                        </div>
                    <?php endforeach; ?>
                <?php else: ?>
                    <p>No hay gráficas disponibles.</p>
                <?php endif; ?>
            </div>
        </div>
    <?php else: ?>
        <div class="login-container">
            <h2>Iniciar Sesión</h2>
            <form action="index.php" method="post">
                <input type="text" name="username" required placeholder="Usuario">
                <input type="password" name="password" required placeholder="Contraseña">
                <button type="submit" name="login">Entrar</button>
            </form>
        </div>
    <?php endif; ?>
</body>
</html>
