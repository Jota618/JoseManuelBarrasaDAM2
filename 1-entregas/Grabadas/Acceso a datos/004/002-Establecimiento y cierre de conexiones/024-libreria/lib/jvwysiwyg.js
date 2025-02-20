let textos = document.querySelectorAll("textarea");
console.log("tengo", textos.length, "textareas");
textos.forEach(function(textarea) {
    let nuevocontenedor = document.createElement("div");
    nuevocontenedor.setAttribute("class", "jvwysiwyg");
    textarea.replaceWith(nuevocontenedor);
    nuevocontenedor.appendChild(textarea);
    textarea.style.display = "none";

    let botonera = document.createElement("div");
    botonera.classList.add("botonera");
    nuevocontenedor.appendChild(botonera);

    let botones = [
        { label: "<b>B</b>", css: "font-weight", value: "bold", tooltip: "Negrita" },
        { label: "<i>I</i>", css: "font-style", value: "italic", tooltip: "Cursiva" },
        { label: "<u>U</u>", css: "text-decoration", value: "underline", tooltip: "Subrayado" },
        { label: "🔗", action: insertarEnlace, tooltip: "Insertar enlace" },
        { label: "📷", action: insertarImagen, tooltip: "Insertar imagen" },
        { label: "↶", action: () => document.execCommand("undo"), tooltip: "Deshacer" },
        { label: "↷", action: () => document.execCommand("redo"), tooltip: "Rehacer" },
        { label: "⬅", action: () => document.execCommand("justifyLeft"), tooltip: "Alinear a la izquierda" },
        { label: "⬆", action: () => document.execCommand("justifyCenter"), tooltip: "Centrar" },
        { label: "➡", action: () => document.execCommand("justifyRight"), tooltip: "Alinear a la derecha" },
        { label: "⏹", action: () => document.execCommand("justifyFull"), tooltip: "Justificar" },
        { label: "🔢", action: () => document.execCommand("insertOrderedList"), tooltip: "Lista numerada" },
        { label: "•", action: () => document.execCommand("insertUnorderedList"), tooltip: "Lista con viñetas" },
        { label: "✂", action: () => document.execCommand("cut"), tooltip: "Cortar" },
        { label: "📋", action: () => document.execCommand("copy"), tooltip: "Copiar" },
        { label: "📥", action: () => document.execCommand("paste"), tooltip: "Pegar" }
    ];

    botones.forEach(btn => {
        let boton = document.createElement("button");
        boton.innerHTML = btn.label;
        boton.title = btn.tooltip;
        boton.classList.add("tooltip-btn");
        botonera.appendChild(boton);
        boton.onclick = btn.action ? btn.action : () => reemplaza(btn.css, btn.value);
    });

    let colorfrente = document.createElement("input");
    colorfrente.setAttribute("type", "color");
    colorfrente.title = "Color de texto";
    botonera.appendChild(colorfrente);
    colorfrente.oninput = function() { reemplaza("color", colorfrente.value); };

    let mieditor = document.createElement("div");
    mieditor.classList.add("editor");
    nuevocontenedor.appendChild(mieditor);
    mieditor.setAttribute("contenteditable", "true");

    mieditor.oninput = function() { actualizaTextarea(); };

    document.body.style.display = "flex";
    document.body.style.justifyContent = "center";
    document.body.style.alignItems = "center";
    document.body.style.height = "100vh";
    document.body.style.margin = "0";

    function actualizaTextarea() {
        textarea.value = mieditor.innerHTML;
    }

    function reemplaza(cssProperty, value) {
        document.execCommand(cssProperty, false, value);
        actualizaTextarea();
    }

    function insertarEnlace() {
        let url = prompt("Introduce la URL:");
        if (url) document.execCommand("createLink", false, url);
    }

    function insertarImagen() {
        let url = prompt("Introduce la URL de la imagen:");
        if (url) {
            let img = document.createElement("img");
            img.src = url;
            img.style.maxWidth = "100%";
            img.style.height = "auto";
            document.execCommand("insertHTML", false, img.outerHTML);
        }
    }
});
