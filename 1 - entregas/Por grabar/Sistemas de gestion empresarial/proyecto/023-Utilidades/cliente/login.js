window.onload = function(){
    console.log("Javascript cargado");
    document.querySelector("#login").onclick = function(){
        console.log("Has pulsado el boton");
        let usuario = document.querySelector("#usuario").value;
        let contrasena = document.querySelector("#contrasena").value;
        console.log(usuario,contrasena);
        let envio = {"usuario":usuario,"contrasena":contrasena};
        console.log(envio);
        // Me conecto a un microservicio y le envío la información json en POST
        fetch("../servidor/loginusuario.php?usuario="+usuario+"&contrasena="+contrasena)
        .then(response => {
          return response.json();                       // Quiero que el servidor me devuelva un json
        })
        .then(data => {
          console.log('Success:', data);                // De momento voy a poner ese JSON en la consola simplemente para ver que la comunicacion es ok
          if(data.resultado == 'ok'){                   // En el caso de que el login sea satisfactorio
            console.log("Entras correctamente")
            localStorage.setItem('crimson_usuario', data.usuario);       // Ahora necesito un mencanismo para que el cliente recuerde quien soy
            document.querySelector("#feedback").style.color = "green"         // Pongo el mensaje de color verde
            document.querySelector("#feedback").innerHTML = "Acceso correcto. Redirigiendo en 5 segundos...";   // Escribo un mensaje de ok
            setTimeout(function(){
                window.location = "escritorio/index.html";                            // Me voy al escritorio                 
            },5000)
          }else{
            console.log("Error al entrar")
            document.querySelector("#feedback").style.color = "red"           // Pongo el mensaje de color rojo
            document.querySelector("#feedback").innerHTML = "Usuario incorrecto. Redirigiendo en 5 segundos...";        // Escribo mensaje de error
            setTimeout(function(){
                window.location = window.location;                              // en 5 segundos vuelvo al mismo sitio
            },5000)
          }
        })
    }
}
