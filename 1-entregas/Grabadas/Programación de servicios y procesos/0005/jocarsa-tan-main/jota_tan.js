/* Funciones de ayuda para trabajar con colores */
function rgbToHsl(rgbString) {
    const match = rgbString.match(/^rgb\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3})\)$/);
    if (!match) {
      throw new Error("Formato RGB inválido. Use 'rgb(x, y, z)'.");
    }
    let r = parseInt(match[1], 10) / 255;
    let g = parseInt(match[2], 10) / 255;
    let b = parseInt(match[3], 10) / 255;
    const max = Math.max(r, g, b), min = Math.min(r, g, b);
    let h, s, l = (max + min) / 2;
    if (max === min) {
      h = s = 0;
    } else {
      let delta = max - min;
      s = l > 0.5 ? delta / (2 - max - min) : delta / (max + min);
      switch(max) {
        case r:
          h = (g - b) / delta + (g < b ? 6 : 0);
          break;
        case g:
          h = (b - r) / delta + 2;
          break;
        case b:
          h = (r - g) / delta + 4;
          break;
      }
      h /= 6;
    }
    return `hsl(${Math.round(h * 360)}, ${Math.round(s * 100)}%, ${Math.round(l * 100)}%)`;
  }
  
  function modifyHslLightness(hslString, newLightness) {
    if (newLightness < 0 || newLightness > 100) {
      throw new Error("El valor de luminosidad debe estar entre 0 y 100.");
    }
    const match = hslString.match(/^hsl\((\d{1,3}),\s*(\d{1,3})%,\s*(\d{1,3})%\)$/);
    if (!match) {
      throw new Error("Formato HSL inválido. Use 'hsl(x, y%, z%)'.");
    }
    const h = parseInt(match[1], 10);
    const s = parseInt(match[2], 10);
    return `hsl(${h}, ${s}%, ${newLightness}%)`;
  }
  
  function interpolateHsl(hsl1, hsl2, percentage) {
    const match1 = hsl1.match(/^hsl\((\d{1,3}),\s*(\d{1,3})%,\s*(\d{1,3})%\)$/);
    const match2 = hsl2.match(/^hsl\((\d{1,3}),\s*(\d{1,3})%,\s*(\d{1,3})%\)$/);
    if (!match1 || !match2) {
      throw new Error("Formato HSL inválido para interpolación.");
    }
    let h1 = parseInt(match1[1], 10), s1 = parseInt(match1[2], 10), l1 = parseInt(match1[3], 10);
    let h2 = parseInt(match2[1], 10), s2 = parseInt(match2[2], 10), l2 = parseInt(match2[3], 10);
  
    // Interpolación circular del tono
    let deltaH = h2 - h1;
    if (deltaH > 180) deltaH -= 360;
    if (deltaH < -180) deltaH += 360;
    let h = (h1 + percentage * deltaH) % 360;
    if (h < 0) h += 360;
    let s = s1 + percentage * (s2 - s1);
    let l = l1 + percentage * (l2 - l1);
    return `hsl(${Math.round(h)}, ${Math.round(s)}%, ${Math.round(l)}%)`;
  }
  
  /* Funciones para filtrar y restablecer */
  function applyFilter() {
    const minValue = parseFloat(document.getElementById('min-value').value);
    const maxValue = parseFloat(document.getElementById('max-value').value);
    let tablas = document.querySelectorAll(".jocarsa-tan");
    tablas.forEach(function(tabla) {
      let celdas = tabla.querySelectorAll("tbody td");
      celdas.forEach(function(celda) {
        let valor = parseFloat(celda.textContent);
        if ((minValue && valor < minValue) || (maxValue && valor > maxValue)) {
          celda.style.display = 'none';
        } else {
          celda.style.display = '';
        }
      });
    });
    calculateStats();
  }
  
  function resetFilter() {
    document.getElementById('min-value').value = 1;
    document.getElementById('min-value-label').textContent = 1;
    document.getElementById('max-value').value = 500;
    document.getElementById('max-value-label').textContent = 500;
    let tablas = document.querySelectorAll(".jocarsa-tan");
    tablas.forEach(function(tabla) {
      let celdas = tabla.querySelectorAll("tbody td");
      celdas.forEach(function(celda) {
        celda.style.display = '';
      });
    });
    document.getElementById('search-bar').value = '';
    calculateStats();
  }
  
  /* Función para ordenar la tabla al hacer clic en los encabezados */
  function sortTable(header, columnIndex) {
    let table = header.closest('table');
    let tbody = table.querySelector("tbody");
    let rows = Array.from(tbody.querySelectorAll("tr"));
    let currentOrder = header.getAttribute('data-order') || 'asc';
    let newOrder = currentOrder === 'asc' ? 'desc' : 'asc';
    header.setAttribute('data-order', newOrder);
  
    rows.sort(function(a, b) {
      let cellA = a.querySelectorAll("td")[columnIndex].textContent.trim();
      let cellB = b.querySelectorAll("td")[columnIndex].textContent.trim();
      let numA = parseFloat(cellA);
      let numB = parseFloat(cellB);
      if (isNaN(numA) || isNaN(numB)) {
        return newOrder === 'asc' ? cellA.localeCompare(cellB) : cellB.localeCompare(cellA);
      } else {
        return newOrder === 'asc' ? numA - numB : numB - numA;
      }
    });
    rows.forEach(function(row) {
      tbody.appendChild(row);
    });
    updateTableStyles();
    calculateStats();
  }
  
  /* Función para buscar en las filas */
  function searchTable() {
    const query = document.getElementById('search-bar').value.toLowerCase();
    let tablas = document.querySelectorAll(".jocarsa-tan");
    tablas.forEach(function(tabla) {
      let rows = tabla.querySelectorAll("tbody tr");
      rows.forEach(function(row) {
        let cells = row.querySelectorAll("td");
        let found = false;
        cells.forEach(function(cell) {
          if (cell.textContent.toLowerCase().includes(query)) {
            found = true;
          }
        });
        row.style.display = found ? '' : 'none';
      });
    });
    calculateStats();
  }
  
  /* Función para actualizar los estilos de la tabla basados en los valores y la opción de color seleccionada */
  function updateTableStyles() {
    let tablas = document.querySelectorAll(".jocarsa-tan");
    tablas.forEach(function(tabla) {
      let scheme = document.getElementById('color-scheme').value;
      let baseColor, bgColor;
      if (scheme === "rojo-verde") {
        baseColor = "rgb(234,0,0)";
        bgColor = "rgb(0,255,0)";
      } else if (scheme === "azul-amarillo") {
        baseColor = "rgb(0,0,255)";
        bgColor = "rgb(255,255,0)";
      } else {
        baseColor = window.getComputedStyle(tabla).color || "rgb(234,0,0)";
        bgColor = window.getComputedStyle(tabla).backgroundColor || "rgb(0,255,0)";
      }
      let colorHsl = rgbToHsl(baseColor);
      let bgColorHsl = (bgColor && bgColor !== 'rgba(0, 0, 0, 0)' && bgColor !== 'transparent') ? rgbToHsl(bgColor) : null;
  
      let celdas = tabla.querySelectorAll("tbody td");
      let valores = [];
      celdas.forEach(function(celda) {
        let valor = parseFloat(celda.textContent);
        if (!isNaN(valor) && celda.style.display !== 'none') {
          valores.push(valor);
        }
      });
      if (valores.length === 0) return;
      let maximo = Math.max(...valores);
      let minimo = Math.min(...valores);
      let range = maximo - minimo;
      if (range === 0) range = 1;
      celdas.forEach(function(celda) {
        let valor = parseFloat(celda.textContent);
        if (isNaN(valor)) return;
        celda.style.color = "black";
        let porcentaje = (valor - minimo) / range;
        let backgroundColorHsl;
        if (bgColorHsl) {
          backgroundColorHsl = interpolateHsl(colorHsl, bgColorHsl, porcentaje);
        } else {
          backgroundColorHsl = modifyHslLightness(colorHsl, 100 - Math.round(porcentaje * 100 / 2));
        }
        celda.style.backgroundColor = backgroundColorHsl;
      });
      tabla.style.background = "none";
      tabla.style.color = "inherit";
    });
    calculateStats();
  }
  
  /* Función que añade interactividad a las celdas (tooltip, clic y actualización tras edición) */
  function addCellInteractivity() {
    let tablas = document.querySelectorAll(".jocarsa-tan");
    tablas.forEach(function(tabla) {
      let celdas = tabla.querySelectorAll("tbody td");
      celdas.forEach(function(celda) {
        celda.addEventListener('mouseenter', function() {
          let valor = parseFloat(celda.textContent);
          celda.setAttribute('title', `Valor: ${valor}`);
        });
        celda.addEventListener('click', function() {
          const currentColor = window.getComputedStyle(celda).backgroundColor;
          const newColor = (currentColor === 'rgb(255, 255, 255)') ? 'lightgray' : 'white';
          celda.style.backgroundColor = newColor;
        });
        celda.addEventListener('blur', function() {
          updateTableStyles();
        });
      });
    });
  }
  
  /* Función para exportar la tabla a CSV */
  function exportTableToCSV() {
    let table = document.querySelector(".jocarsa-tan");
    if (!table) return;
    let csv = [];
    let rows = table.querySelectorAll("tr");
    rows.forEach(function(row) {
      let rowData = [];
      let cols = row.querySelectorAll("th, td");
      cols.forEach(function(col) {
        rowData.push('"' + col.textContent.replace(/"/g, '""') + '"');
      });
      csv.push(rowData.join(","));
    });
    let csvFile = new Blob([csv.join("\n")], { type: "text/csv" });
    let downloadLink = document.createElement("a");
    downloadLink.download = "tabla.csv";
    downloadLink.href = window.URL.createObjectURL(csvFile);
    downloadLink.style.display = "none";
    document.body.appendChild(downloadLink);
    downloadLink.click();
    document.body.removeChild(downloadLink);
  }
  
  /* Función para calcular estadísticas: promedio, mediana, mínimo y máximo */
  function calculateStats() {
    let table = document.querySelector(".jocarsa-tan");
    if (!table) return;
    let celdas = table.querySelectorAll("tbody td");
    let valores = [];
    celdas.forEach(function(celda) {
      if (celda.style.display !== 'none') {
        let valor = parseFloat(celda.textContent);
        if (!isNaN(valor)) {
          valores.push(valor);
        }
      }
    });
    if (valores.length === 0) {
      document.getElementById('stats').innerHTML = "No hay datos visibles para análisis.";
      return;
    }
    let suma = valores.reduce((a, b) => a + b, 0);
    let promedio = (suma / valores.length).toFixed(2);
    valores.sort((a, b) => a - b);
    let mediana;
    let mid = Math.floor(valores.length / 2);
    if (valores.length % 2 === 0) {
      mediana = ((valores[mid - 1] + valores[mid]) / 2).toFixed(2);
    } else {
      mediana = valores[mid].toFixed(2);
    }
    let minimo = Math.min(...valores);
    let maximo = Math.max(...valores);
    document.getElementById('stats').innerHTML = `<p>Promedio: ${promedio}</p>
      <p>Mediana: ${mediana}</p>
      <p>Mínimo: ${minimo}</p>
      <p>Máximo: ${maximo}</p>`;
  }
  
  /* Inicialización */
  document.addEventListener("DOMContentLoaded", function() {
    updateTableStyles();
    addCellInteractivity();
  });
  