<?php include "inc/morir.php" ?>
<?php include "inc/idiomas.php" ?>
<!doctype html>
<html lang="es">
  <head>
    <title>
      <?php echo $idioma['titulo']['contenido']?>
    </title>
    <meta charset="utf-8">
    <link rel="stylesheet" href="estilologin.css">
    <link rel="icon" type="image/png" sizes="512x512" href="img/logo.png">
    <link rel="shortcut icon" href="img/logo.png">
    <script src="login.js" defer></script>
    <style>
      .password-wrapper {
        display: flex;
        align-items: center;
        gap: 5px; /* Espacio entre input y botón */
      }

      #contrasena {
        flex: 1;
      }

      .toggle-password {
        background: none;
        border: none;
        font-size: 18px;
        cursor: pointer;
        padding: 5px;
        width: 40px;
        height: 40px;
      }
    </style>
  </head>
  <body>
    <div id="formlogin">
      <img src="img/logo.png" id="logo">
      <input type="text" id="usuario" placeholder="<?php echo $idioma['usuario']['contenido']?>">

      <div class="password-wrapper">
        <input type="password" id="contrasena" placeholder="<?php echo $idioma['contrasena']['contenido']?>">
        <button type="button" class="toggle-password" onclick="togglePassword()">
          👁️
        </button>
      </div>

      <button id="login"><?php echo $idioma['login']['contenido']?></button>
      <div id="feedback"></div>
    </div>
    <div id="toast"></div>

    <script>
      function togglePassword() {
        const passwordField = document.getElementById("contrasena");
        const toggleButton = document.querySelector(".toggle-password");
        
        if (passwordField.type === "password") {
          passwordField.type = "text";
          toggleButton.textContent = "🚫"; // Ojo cerrado
        } else {
          passwordField.type = "password";
          toggleButton.textContent = "👁️"; // Ojo abierto
        }
      }
    </script>
  </body>
</html>
