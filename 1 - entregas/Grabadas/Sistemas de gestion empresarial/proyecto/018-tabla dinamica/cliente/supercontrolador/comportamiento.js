window.onload = function(){
    fetch("../../servidor/lista_tablas.php")                        // LLamo a un microservicio que me da la lista de tablas
        .then(response => {
          return response.json();                                   // Quiero que el servidor me devuelva un json
        })
        .then(datos => {
            let menu = document.querySelector("nav ul")             // Selecciono el menu donde voy a poner las entradas dinamicas
            datos.forEach(function(tabla){                          // Para cada una de las tablas que han venido de la base de datos
                let nombre_de_la_tabla = tabla['Tables_in_crimson'];    // Atrapo el nombre de la tabla que viene del fetch
                let elemento = document.createElement("li")         // Creo en memoria un nuevo elemento li
                elemento.textContent = nombre_de_la_tabla           // A ese elemento li le pongo como texto el nombre de la tabl
                menu.appendChild(elemento)                          // Lo añado al menú
                
            })
        })
}
