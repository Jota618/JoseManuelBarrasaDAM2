/////////////////////////////////// VARIABLES GLOBALES DEL PROGRAMA /////////////////////////////////////////////

var columnas_tabla = []                                             // Creo una variable global para almacenar las columnas
var aplicaciones;

/////////////////////////////////// VARIABLES GLOBALES DEL PROGRAMA /////////////////////////////////////////////

window.onload = function(){
	let aplicacion = localStorage.getItem("crimson_aplicacion")
    console.log("LA aplicacion es:"+aplicacion)
    
    listadoTablas(aplicacion);
    listadoDocumentos();
    
     
    //cargaDatosTabla("clientes")                                 // Cuando arranca el programa, le pongo una tabla por defecto
    
    	fetch("../../servidor/?o=estadisticastablas")
    	.then(function(result){
    		return result.json()
    	})
    	.then(function(datos){
    	console.log("el servidor dice ok")
    		let nuevografico = new JVGrafica(datos,"#dc143c","table tbody","Resgistros en cada tabla");
			nuevografico.anillo()
    	})
			
			
			
    
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
	//////////////////////////////// IMPRIMIR ///////////////////////////////////
	
	document.querySelector("#imprimir").onclick = function(){
		window.print()
	}
	
	////////////////////////////// BUSINESS ANALYTICS //////////////////////////
	
	document.querySelector("#businessanalytics").onclick = function(){
		console.log("Has hecho click")
		document.querySelector("section").innerHTML = ""
		let marco = document.createElement("iframe")
		marco.setAttribute("src","../bi/")
		document.querySelector("section").appendChild(marco)
	}
	
	////////////////////////////// AYUDA //////////////////////////
	
	document.querySelector("#ayuda").onclick = function(){
		console.log("vamos a la ayuda")
		let marco = document.createElement("iframe")
		marco.setAttribute("src","ayuda/")
		document.querySelector("main").appendChild(marco)
	}
	////////////////////////// RECARGAR PAGINA
	document.querySelector("h1").onclick = function(){
		window.location = window.location
	}
}


 
 
 
 
