<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Tan | Tabla Interactiva y Personalizable</title>
    <script defer src="jota_tan.js"></script>
    <link rel="stylesheet" href="estilos.css">
  </head>
  <body>
    <?php
      $columnas = 8;
      $filas = 16;
    ?>
    <h1>Tabla con Filtros, Ordenamiento, Edición y Exportación</h1>

    <!-- Controles para filtros, búsqueda, personalización y exportación -->
    <div id="controls">
      <!-- Filtros con sliders -->
      <div id="filter-controls">
        <h2>Filtros</h2>
        <label for="min-value">Valor mínimo:</label>
        <input type="range" id="min-value" min="1" max="500" value="1" oninput="document.getElementById('min-value-label').textContent = this.value">
        <span id="min-value-label">1</span>
        <br>
        <label for="max-value">Valor máximo:</label>
        <input type="range" id="max-value" min="1" max="500" value="500" oninput="document.getElementById('max-value-label').textContent = this.value">
        <span id="max-value-label">500</span>
        <br>
        <button onclick="applyFilter()">Aplicar Filtro</button>
        <button onclick="resetFilter()">Restablecer Filtro</button>
      </div>

      <!-- Búsqueda en filas -->
      <div id="search-controls">
        <h2>Búsqueda en filas</h2>
        <label for="search-bar">Buscar:</label>
        <input type="text" id="search-bar" placeholder="Buscar en filas..." oninput="searchTable()">
      </div>

      <!-- Personalización de colores -->
      <div id="customization-controls">
        <h2>Personalización de Colores</h2>
        <label for="color-scheme">Esquema de colores:</label>
        <select id="color-scheme" onchange="updateTableStyles();">
          <option value="rojo-verde">Rojo a Verde</option>
          <option value="azul-amarillo">Azul a Amarillo</option>
          <option value="default">Por defecto</option>
        </select>
      </div>

      <!-- Exportación y estadísticas -->
      <div id="export-controls">
        <h2>Exportación y Análisis</h2>
        <button onclick="exportTableToCSV()">Exportar a CSV</button>
        <div id="stats"></div>
      </div>
    </div>

    <!-- Tabla interactiva generada por PHP -->
    <table class="jocarsa-tan">
      <thead>
        <tr>
          <?php
            for($i = 0; $i < $columnas; $i++){
              // Se añade onclick para ordenar según la columna
              echo '<th onclick="sortTable(this, '.$i.')">'.$i.'</th>';
            }
          ?>
        </tr>
      </thead>
      <tbody>
        <?php
          for($i = 0; $i < $filas; $i++){
            echo '<tr>';
            for($j = 0; $j < $columnas; $j++){
              // Se marca cada celda como editable para la edición en línea
              echo '<td contenteditable="true">'.rand(1,500).'</td>';
            }
            echo '</tr>';
          }
        ?>
      </tbody>
    </table>
        ?>
      </tbody>
    </table>
  </body>
</html>
