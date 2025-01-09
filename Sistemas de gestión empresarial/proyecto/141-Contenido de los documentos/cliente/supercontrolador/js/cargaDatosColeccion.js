function cargaDatosColeccion(coleccion) {
    console.log("Voy a cargar los datos de la colección");
    document.querySelector("table").innerHTML = ""; // Limpiar contenido previo

    fetch("../../servidor/?o=listadocumentos&coleccion=" + coleccion) // Llamada al servidor
        .then(response => response.json()) // Convertir respuesta a JSON
        .then(datos => {
            console.log(datos);
            document.querySelector("table").style.display = "block";
 				document.querySelector("table").classList.add("contienedocumentos")
            // Renderizar cada documento JSON
            datos.forEach(dato => {
                const articleHTML = renderJSONToHTML(dato); // Convertir JSON a HTML
                document.querySelector("table").innerHTML += `
                    <article style="border: 1px solid #ccc; margin: 10px; padding: 10px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
                        ${articleHTML}
                    </article>
                `;
            });
        });
}

// Función recursiva para convertir JSON en HTML
function renderJSONToHTML(json) {
    if (typeof json !== "object" || json === null) {
        return `<span>${json}</span>`; // Valor simple (string, number, etc.)
    }

    if (Array.isArray(json)) {
        // Manejar arrays
        return `
            <ul style="list-style-type: square; margin-left: 20px;">
                ${json.map(item => `<li>${renderJSONToHTML(item)}</li>`).join("")}
            </ul>
        `;
    }

    // Manejar objetos
    return `
        <div style="margin-left: 10px;">
            ${Object.entries(json).map(([key, value]) => `
                <div style="margin-bottom: 8px;">
                    <strong style="color: #333;">${key}:</strong> ${renderJSONToHTML(value)}
                </div>
            `).join("")}
        </div>
    `;
}

