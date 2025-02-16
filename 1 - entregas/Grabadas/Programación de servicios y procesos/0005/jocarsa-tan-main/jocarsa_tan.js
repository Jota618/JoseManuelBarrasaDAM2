// Existing helper functions
function rgbToHsl(rgbString) {
    const match = rgbString.match(/^rgb\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3})\)$/);
    if (!match) {
        throw new Error("Invalid RGB format. Use 'rgb(x, y, z)' format.");
    }

    let r = parseInt(match[1], 10);
    let g = parseInt(match[2], 10);
    let b = parseInt(match[3], 10);

    r /= 255;
    g /= 255;
    b /= 255;

    const max = Math.max(r, g, b);
    const min = Math.min(r, g, b);

    let h, s, l = (max + min) / 2;

    if (max === min) {
        h = s = 0; // achromatic
    } else {
        const delta = max - min;
        s = l > 0.5 ? delta / (2 - max - min) : delta / (max + min);
        switch (max) {
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

    h = Math.round(h * 360); // Hue in degrees
    s = Math.round(s * 100); // Saturation as percentage
    l = Math.round(l * 100); // Luminance as percentage

    return `hsl(${h}, ${s}%, ${l}%)`;
}

function modifyHslLightness(hslString, newLightness) {
    // Validate the new lightness value
    if (newLightness < 0 || newLightness > 100) {
        throw new Error("Lightness value must be between 0 and 100.");
    }

    // Extract the HSL values from the input string
    const match = hslString.match(/^hsl\((\d{1,3}),\s*(\d{1,3})%,\s*(\d{1,3})%\)$/);
    if (!match) {
        throw new Error("Invalid HSL format. Use 'hsl(x, y%, z%)' format.");
    }

    // Parse the HSL values
    const h = parseInt(match[1], 10); // Hue
    const s = parseInt(match[2], 10); // Saturation
    // Lightness is replaced with the new value

    // Return the modified HSL string
    return `hsl(${h}, ${s}%, ${newLightness}%)`;
}

// New interpolation function
function interpolateHsl(hsl1, hsl2, percentage) {
    const match1 = hsl1.match(/^hsl\((\d{1,3}),\s*(\d{1,3})%,\s*(\d{1,3})%\)$/);
    const match2 = hsl2.match(/^hsl\((\d{1,3}),\s*(\d{1,3})%,\s*(\d{1,3})%\)$/);
    
    if (!match1 || !match2) {
        throw new Error("Invalid HSL format for interpolation.");
    }

    let h1 = parseInt(match1[1], 10);
    let s1 = parseInt(match1[2], 10);
    let l1 = parseInt(match1[3], 10);

    let h2 = parseInt(match2[1], 10);
    let s2 = parseInt(match2[2], 10);
    let l2 = parseInt(match2[3], 10);

    // Handle hue interpolation (circular)
    let deltaH = h2 - h1;
    if (deltaH > 180) deltaH -= 360;
    if (deltaH < -180) deltaH += 360;
    let h = (h1 + percentage * deltaH) % 360;
    if (h < 0) h += 360;

    // Interpolate saturation and lightness linearly
    let s = s1 + percentage * (s2 - s1);
    let l = l1 + percentage * (l2 - l1);

    return `hsl(${Math.round(h)}, ${Math.round(s)}%, ${Math.round(l)}%)`;
}

// Function to apply the filter
function applyFilter() {
    const minValue = parseFloat(document.getElementById('min-value').value);
    const maxValue = parseFloat(document.getElementById('max-value').value);

    let tablas = document.querySelectorAll(".jocarsa-tan"); // Select all tables with the class

    tablas.forEach(function(tabla) {
        let celdas = tabla.querySelectorAll("tbody td");

        celdas.forEach(function(celda) {
            let valor = parseFloat(celda.textContent);
            
            // Apply filter: check if the value is within the specified range
            if ((minValue && valor < minValue) || (maxValue && valor > maxValue)) {
                celda.style.display = 'none'; // Hide the cell if it doesn't meet the criteria
            } else {
                celda.style.display = ''; // Show the cell if it meets the criteria
            }
        });
    });
}

// Add interactivity to the cells
function addCellInteractivity() {
    let tablas = document.querySelectorAll(".jocarsa-tan");

    tablas.forEach(function(tabla) {
        let celdas = tabla.querySelectorAll("tbody td");

        celdas.forEach(function(celda) {
            // Hover effect: display the cell value on hover
            celda.addEventListener('mouseenter', function() {
                const valor = parseFloat(celda.textContent);
                celda.setAttribute('title', `Valor: ${valor}`); // Show value as tooltip
            });

            // Click effect: change background color on click
            celda.addEventListener('click', function() {
                const currentColor = window.getComputedStyle(celda).backgroundColor;
                const newColor = (currentColor === 'rgb(255, 255, 255)') ? 'lightgray' : 'white';
                celda.style.backgroundColor = newColor; // Toggle between white and lightgray
            });
        });
    });
}

// Main script
let tablas = document.querySelectorAll(".jocarsa-tan"); // Select all tables with the class

tablas.forEach(function(tabla) {
    let color = window.getComputedStyle(tabla).color; // Get computed color
    let bgColor = window.getComputedStyle(tabla).backgroundColor; // Get computed background color

    // Default color if not defined
    if (!color || color === 'rgba(0, 0, 0, 0)' || color === 'transparent') {
        color = "rgb(255, 0, 0)"; // Red
    }

    // Convert colors to HSL
    let colorHsl = rgbToHsl(color);
    let bgColorHsl = bgColor && bgColor !== 'rgba(0, 0, 0, 0)' && bgColor !== 'transparent' ? rgbToHsl(bgColor) : null;

    let celdas = tabla.querySelectorAll("tbody td");
    let valores = []; // Create an empty array

    celdas.forEach(function(celda) {
        let valor = parseFloat(celda.textContent);
        if (!isNaN(valor)) {
            valores.push(valor); // Add numerical values to the array
        }
    });

    if (valores.length === 0) {
        console.warn("No numerical values found in table:", tabla);
        return; // Skip this table if no numerical values are found
    }

    let maximo = Math.max(...valores);
    let minimo = Math.min(...valores);

    // Avoid division by zero if maximo equals minimo
    let range = maximo - minimo;
    if (range === 0) range = 1;

    // Iterate through the cells again to apply styles
    celdas.forEach(function(celda) {
        let valor = parseFloat(celda.textContent);
        if (isNaN(valor)) return; // Skip non-numerical cells

        celda.style.color = "black"; // Set text color to black

        // Calculate the percentage based on the value's position between min and max
        let porcentaje = ((valor - minimo) / range); // Range normalized between 0 and 1

        let backgroundColorHsl;

        if (bgColorHsl) {
            // Dual color gradient: interpolate between colorHsl and bgColorHsl
            backgroundColorHsl = interpolateHsl(colorHsl, bgColorHsl, porcentaje);
        } else {
            // Single color gradient: adjust lightness based on porcentaje
            backgroundColorHsl = modifyHslLightness(colorHsl, 100 - Math.round(porcentaje * 100 / 2));
        }

        celda.style.backgroundColor = backgroundColorHsl;
    });
    tabla.style.background = "none";
    tabla.style.color = "inherit";
});

// Call the function to add interactivity
addCellInteractivity();
