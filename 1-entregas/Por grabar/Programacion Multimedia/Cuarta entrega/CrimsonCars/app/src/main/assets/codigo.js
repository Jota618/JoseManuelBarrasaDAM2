
fetch("http://192.168.1.145/JoseManuelBarrasaDAM2/Sistemas%20de%20gestión%20empresarial/proyecto/114-endpoint%20publico/endpointpublico/index.php")
.then(function(result){
		return result.json()
	})
	.then(function(datos){


        let contenedor = document.querySelector("body")
        let plantilla = document.querySelector("#plantillacoche")
            datos.forEach(function(dato){
                let instancia = plantilla.content.cloneNode(true)
                instancia.querySelector("h3").textContent = dato.nombre
                instancia.querySelector(".descripcion").textContent = dato.descripcion
                instancia.querySelector(".precio").textContent = dato.precio
                contenedor.appendChild(instancia)
            })

	})
	.catch(function(error){
	    document.write("ok<br>")
	    document.write("ok<br>")
	    document.write("ok<br>")
	    document.write("ok<br>")
	    document.write("ok<br>")
	    document.write("ok<br>")
	    document.write(error)
	})


