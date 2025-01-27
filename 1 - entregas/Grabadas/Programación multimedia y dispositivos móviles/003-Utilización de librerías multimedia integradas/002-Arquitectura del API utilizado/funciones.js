document.getElementById('capture').addEventListener('click', async () => {
    const resolution = document.getElementById('resolution').value;

    try {
        // Obtener el video del stream que está en tiempo real
        const video = document.getElementById('video');
        
        // Crear un canvas para capturar el frame actual del video
        let canvas = document.createElement('canvas');
        const [width, height] = resolution === 'original' 
            ? [video.videoWidth, video.videoHeight] // Usamos el tamaño del video actual
            : resolution.split('x').map(Number);

        canvas.width = width;
        canvas.height = height;

        const ctx = canvas.getContext('2d');
        ctx.drawImage(video, 0, 0, width, height);  // Capturamos el frame actual del video

        // Convertir a Blob y enviar al backend
        canvas.toBlob(async (blob) => {
            const formData = new FormData();
            formData.append('screenshot', blob, 'screenshot.png');

            const response = await fetch('captura.php', {
                method: 'POST',
                body: formData
            });

            const result = await response.text();
            document.getElementById('preview').innerHTML = `
                <h2>Captura Guardada:</h2>
                <img src="${result}" alt="Captura de Pantalla">
            `;
        });
    } catch (err) {
        console.error('Error al capturar la pantalla:', err);
    }
});

// Función para mostrar el stream de la pantalla en tiempo real
async function startStreaming() {
    try {
        // Solicitar acceso a la pantalla
        const stream = await navigator.mediaDevices.getDisplayMedia({
            video: true
        });

        // Mostrar el stream en el elemento <video>
        const video = document.getElementById('video');
        video.srcObject = stream;

        // No detener el stream cuando el usuario hace la captura, solo cuando se cierre el stream
        document.getElementById('capture').addEventListener('click', () => {
            // El stream sigue activo, solo tomamos la captura sin detenerlo
        });
    } catch (err) {
        console.error('Error al iniciar el streaming:', err);
    }
}

// Iniciar el streaming cuando la página carga
window.onload = startStreaming;
