let originalData = [];

function renderCars(filteredData) {
    const container = document.getElementById("carsContainer");
    const plantilla = document.querySelector("#plantillacoche");
    
    // Clear current content
    container.innerHTML = '';
    
    filteredData.forEach(dato => {
        const instancia = plantilla.content.cloneNode(true);
        instancia.querySelector("h3").textContent = dato.nombre;
        instancia.querySelector(".descripcion").textContent = dato.descripcion;
        instancia.querySelector(".precio").textContent = 
            new Intl.NumberFormat('es-ES', { 
                style: 'currency', 
                currency: 'EUR' 
            }).format(dato.precio);
        
        container.appendChild(instancia);
    });
}

function filterCars() {
    const searchTerm = document.getElementById("searchInput").value.toLowerCase();
    const priceFilter = document.getElementById("filterPrice").value;
    
    const filtered = originalData.filter(car => {
        // Search filter
        const matchesSearch = car.nombre.toLowerCase().includes(searchTerm) || 
                            car.descripcion.toLowerCase().includes(searchTerm);
        
        // Price filter
        const [min, max] = priceFilter.split("-").map(Number);
        const matchesPrice = priceFilter === 'all' || 
                           (car.precio >= min && car.precio <= max);
        
        return matchesSearch && matchesPrice;
    });
    
    renderCars(filtered);
}

// Debounce function for search input
function debounce(func, timeout = 300) {
    let timer;
    return (...args) => {
        clearTimeout(timer);
        timer = setTimeout(() => { func.apply(this, args); }, timeout);
    };
}

// Event Listeners
document.getElementById("searchInput").addEventListener('input', debounce(filterCars));
document.getElementById("filterPrice").addEventListener('change', filterCars);

// Fetch data
fetch("http://192.168.1.145/JoseManuelBarrasaDAM2/Sistemas%20de%20gestión%20empresarial/proyecto/114-endpoint%20publico/endpointpublico/index.php")
.then(result => result.json())
.then(datos => {
    originalData = datos;
    renderCars(datos);
})
.catch(error => {
    const errorDiv = document.createElement('div');
    errorDiv.className = 'error';
    errorDiv.innerHTML = `
        <h3>Error de conexión</h3>
        <p>No se pudieron cargar los datos: ${error.message}</p>
        <button onclick="location.reload()">Reintentar</button>
    `;
    document.body.appendChild(errorDiv);
});