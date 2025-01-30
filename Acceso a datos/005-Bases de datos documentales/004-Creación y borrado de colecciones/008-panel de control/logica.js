document.addEventListener('DOMContentLoaded', async () => {
    const urlParams = new URLSearchParams(window.location.search);
    const formulario = document.getElementById('formularioDinamico');
    const contenedorEstatico = document.getElementById('camposEstaticos');
    const contenedorDinamico = document.getElementById('contenedorCamposDinamicos');

    try {
        // Cargar y analizar el archivo XML
        const respuesta = await fetch('modelos/' + urlParams.get('f') + '.xml');
        const xmlTexto = await respuesta.text();
        const parser = new DOMParser();
        const xml = parser.parseFromString(xmlTexto, 'application/xml');

        // Renderizar campos estáticos
        const camposEstaticos = xml.querySelectorAll('fields > field');
        camposEstaticos.forEach(campo => {
            renderizarCampo(campo, contenedorEstatico);
        });

        // Renderizar grupos de campos dinámicos
        const gruposDinamicos = xml.querySelectorAll('dynamicFields > fieldGroup');
        gruposDinamicos.forEach(grupo => {
            renderizarGrupoDinamico(grupo, contenedorDinamico);
        });

        // Manejo del envío del formulario
        formulario.addEventListener('submit', async (evento) => {
            evento.preventDefault();

            // Recopilar datos de los campos estáticos
            const datosEstaticos = {};
            camposEstaticos.forEach(campo => {
                const nombre = campo.querySelector('name').textContent;
                datosEstaticos[nombre] = document.querySelector(`[name="${nombre}"]`).value;
            });

            // Recopilar datos de los campos dinámicos
            const datosDinamicos = [];
            contenedorDinamico.querySelectorAll('.grupo-dinamico').forEach(grupo => {
                const grupoDatos = Array.from(grupo.querySelectorAll('.linea-dinamica')).map(linea => {
                    const lineaDatos = {};
                    linea.querySelectorAll('input').forEach(input => {
                        lineaDatos[input.name] = input.value;
                    });
                    return lineaDatos;
                });
                datosDinamicos.push(grupoDatos);
            });

            // Enviar datos recopilados
            const datosFormulario = {
                datosEstaticos,
                datosDinamicos,
            };

            try {
                const respuesta = await fetch('guardaxml.php?f=' + urlParams.get('f'), {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(datosFormulario),
                });

                const resultado = await respuesta.text();
                console.log(resultado);
                alert('Formulario enviado con éxito!');
            } catch (error) {
                console.error('Error:', error);
                alert('Ocurrió un error al enviar el formulario.');
            }
        });
    } catch (error) {
        console.error('Error al cargar XML:', error);
    }

    // Función para renderizar un campo individual
    function renderizarCampo(campo, contenedor) {
        const nombre = campo.querySelector('name').textContent;
        const tipo = campo.querySelector('type').textContent;
        const marcador = campo.querySelector('placeholder').textContent;
        const requerido = campo.querySelector('required').textContent === 'true';

        const input = document.createElement('input');
        input.type = tipo;
        input.name = nombre;
        input.placeholder = marcador;
        input.required = requerido;
        contenedor.appendChild(input);
        contenedor.appendChild(document.createElement('br'));
    }

    // Función para renderizar grupos de campos dinámicos
    function renderizarGrupoDinamico(grupo, contenedor) {
        const nombreGrupo = grupo.getAttribute('name');
        const campos = Array.from(grupo.querySelectorAll('field'));

        const contenedorGrupo = document.createElement('div');
        contenedorGrupo.classList.add('grupo-dinamico');
        contenedor.appendChild(contenedorGrupo);

        const botonAgregar = document.createElement('button');
        botonAgregar.type = 'button';
        botonAgregar.textContent = `+ Agregar ${nombreGrupo}`;
        botonAgregar.classList.add('boton-agregar-linea');
        contenedor.appendChild(botonAgregar);

        function renderizarLineaDinamica() {
            const linea = document.createElement('div');
            linea.classList.add('linea-dinamica');

            campos.forEach(campo => {
                const nombre = campo.querySelector('name').textContent;
                const tipo = campo.querySelector('type').textContent;
                const marcador = campo.querySelector('placeholder').textContent;
                const requerido = campo.querySelector('required').textContent === 'true';

                const input = document.createElement('input');
                input.type = tipo;
                input.name = `${nombreGrupo}[${nombre}][]`;
                input.placeholder = marcador;
                input.required = requerido;
                linea.appendChild(input);
            });

            const botonEliminar = document.createElement('button');
            botonEliminar.type = 'button';
            botonEliminar.textContent = '-';
            botonEliminar.classList.add('boton-eliminar-linea');
            botonEliminar.addEventListener('click', () => {
                contenedorGrupo.removeChild(linea);
            });
            linea.appendChild(botonEliminar);

            contenedorGrupo.appendChild(linea);
        }

        botonAgregar.addEventListener('click', renderizarLineaDinamica);
        renderizarLineaDinamica(); // Renderizar una línea inicial
    }
});
