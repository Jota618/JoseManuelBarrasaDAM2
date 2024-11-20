/////////////////////////////////// VARIABLES GLOBALES DEL PROGRAMA /////////////////////////////////////////////

var columnas_tabla = []                                             // Creo una variable global para almacenar las columnas
var aplicaciones;

/////////////////////////////////// VARIABLES GLOBALES DEL PROGRAMA /////////////////////////////////////////////

window.onload = function(){
    /////////////////////////////////// LISTADO DE TABLAS /////////////////////////////////////////////
    
    fetch("../../servidor/?o=listatablas")                        // LLamo a un microservicio que me da la lista de tablas
        .then(response => {
          return response.json();                                   // Quiero que el servidor me devuelva un json
        })
        .then(datos => {
        console.log(datos)
        		poblarMenuNavegacion(datos,"tabla");
        })
    
    /////////////////////////////////// LISTADO DE TABLAS /////////////////////////////////////////////
    
    /////////////////////////////////// LISTADO DE COLECCIONES DE MONGO /////////////////////////////////////////////
    
    fetch("../../servidor/?o=listacolecciones")                        // LLamo a un microservicio que me da la lista de tablas
        .then(response => {
          return response.json();                                   // Quiero que el servidor me devuelva un json
        })
        .then(datos => {
        console.log("Vamos con las colecciones")
        console.log(datos)
        		poblarMenuNavegacion(datos,"coleccion");
        })
    
    /////////////////////////////////// LISTADO DE COLECCIONES DE MONGO /////////////////////////////////////////////
     
    cargaDatosTabla("clientes")                                 // Cuando arranca el programa, le pongo una tabla por defecto
    
    /////////////////////////////////// CLICK VENTANA MODAL PARA INSERTAR /////////////////////////////////////////////
    
    document.querySelector("#insertar").onclick = function(){
        document.querySelector("#modal").style.display = "block"
        document.querySelector("#modal").classList.remove("desaparece")
        document.querySelector("#modal").classList.add("aparece")
    }
    document.querySelector("#modal").onclick = function(){
        
        document.querySelector("#modal").classList.remove("aparece")
        document.querySelector("#modal").classList.add("desaparece")
        setTimeout(function(){
            document.querySelector("#modal").style.display = "none"
        },1000)
    }
    document.querySelector("#contienemodal").onclick = function(event){
        event.stopPropagation()
    }
    
    /////////////////////////////////// ABRIR CORREO ELECTRÓNICO /////////////////////////////////////////////
    
    document.querySelector("#mail").onclick = function(){
   
    document.querySelector("section").innerHTML = ""
    		document.querySelector("section").style.display = "block"
    		let marco = document.createElement("iframe")
    		marco.setAttribute("src","http://localhost:5000/")
    		document.querySelector("section").appendChild(marco)
    }
    
    ////////////////////////////////// CARGO LAS APLICACIONES /////////////////////////////////////////////
    
    fetch("apps/apps.json")
    .then(function(response){
    	return response.json()
    })
    .then(function(datos){
    	console.log(datos)
    	aplicaciones = datos
    })

}


 
 
 
 
