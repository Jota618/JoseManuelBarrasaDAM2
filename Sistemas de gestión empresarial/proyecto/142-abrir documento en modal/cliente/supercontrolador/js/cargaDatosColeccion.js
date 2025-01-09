function cargaDatosColeccion(coleccion) {
    console.log("Voy a cargar los datos de la colección");
    document.querySelector("table").innerHTML = ""; // Limpiar contenido previo

    fetch("../../servidor/?o=listadocumentos&coleccion=" + coleccion)
        .then(response => response.json()) // Convertir respuesta a JSON
        .then(datos => {
            console.log(datos);
            document.querySelector("table").style.display = "block";

            datos.forEach((dato, index) => {
                const articleHTML = renderJSONToHTML(dato);

                const articleElement = `
                    <article 
                        class="clickable-article" 
                        data-content='${JSON.stringify(dato)}'
                        style="border: 1px solid #ccc; margin: 10px; padding: 10px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); cursor: pointer;">
                        ${articleHTML}
                    </article>
                `;
                document.querySelector("table").innerHTML += articleElement;
            });

            // Add event listeners to all articles
            document.querySelectorAll(".clickable-article").forEach(article => {
                article.addEventListener("click", function () {
                    const dataContent = JSON.parse(this.getAttribute("data-content"));
                    openModal(dataContent);
                });
            });
        });
}

// Function to render JSON to HTML (same as before)
function renderJSONToHTML(json) {
    if (typeof json !== "object" || json === null) {
        return `<span>${json}</span>`; // Simple values
    }

    if (Array.isArray(json)) {
        return `
            <ul style="list-style-type: square; margin-left: 20px;">
                ${json.map(item => `<li>${renderJSONToHTML(item)}</li>`).join("")}
            </ul>
        `;
    }

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

// Function to open the modal and display content
function openModal(content) {
    const modal = document.getElementById("modal");
    const modalContent = document.getElementById("contienemodal");

    // Clear previous content and add new content
    modalContent.innerHTML = renderJSONToHTML(content);

    // Make the modal visible
    modal.style.display = "block";

    // Add a close functionality (optional)
    modal.addEventListener("click", function (e) {
        if (e.target === modal) {
            modal.style.display = "none";
        }
    });
}

