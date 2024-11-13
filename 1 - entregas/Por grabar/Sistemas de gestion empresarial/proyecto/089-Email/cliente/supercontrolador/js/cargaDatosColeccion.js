function cargaDatosColeccion(coleccion){
	console.log("Voy a cargar los datos de la coleccion")
	document.querySelector("table").innerHTML = ""
	fetch("../../servidor/?o=listadocumentos&coleccion="+coleccion)                        // LLamo a un microservicio que me da la lista de tablas
        .then(response => {
          return response.json();                                   // Quiero que el servidor me devuelva un json
        })
        .then(datos => {
        
        		console.log(datos)
        		datos.forEach(function(){
        		document.querySelector("table").style.display = "block"
        			document.querySelector("table").innerHTML+= `
        				<article>
        					<h3>Documento</h3>
        				</article>
        			`
        			
        			
        		})
        })
}
