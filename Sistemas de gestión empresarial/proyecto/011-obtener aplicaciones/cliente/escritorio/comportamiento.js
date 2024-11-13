window.onload = function(){
    fetch("../../servidor/lista_aplicaciones.php")         // LLamo a un microservicio que me da la lista de aplicaciones
        .then(response => {
          return response.json();                       // Quiero que el servidor me devuelva un json
        })
        .then(data => {
            console.log(data)                           // Vomito el json en pantalla
        })
}
