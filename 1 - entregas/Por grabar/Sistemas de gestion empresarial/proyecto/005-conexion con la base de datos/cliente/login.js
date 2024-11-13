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
        fetch("../servidor/loginusuario.php", {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(envio), 
        })
        .then(response => {
          return response.json();                       // Quiero que el servidor me devuelva un json
        })
        .then(data => {
          console.log('Success:', data);                // De momento voy a poner ese JSON en la consola simplemente para ver que la comunicacion es ok
        })
    }
}
