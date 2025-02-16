<!doctype html>
<html>
	<head>
		<script defer src="jocarsa_tan.js"></script>
		<link rel="stylesheet" href="estilos.css"> <!-- Enlace al archivo CSS externo -->
	</head>
	<body>
		<?php
			$columnas = 8;
			$filas = 16;
		?>
		<h1>Una tabla con filtros</h1>
		
		<!-- Formulario para filtros -->
		<div id="filters">
			<label for="min-value">Valor mínimo: </label>
			<input type="number" id="min-value" placeholder="Minimo" />
			<label for="max-value">Valor máximo: </label>
			<input type="number" id="max-value" placeholder="Máximo" />
			<button onclick="applyFilter()">Aplicar Filtro</button>
		</div>
		
		<table class="jocarsa-tan" style="color:rgb(234,0,0);background:rgb(0,255,0);">
			<thead>
				<tr>
					<?php
						for($i = 0;$i<$columnas;$i++){
							echo '<th>'.$i.'</th>';
						}
					?>
				</tr>
			</thead>
			<tbody>
				<?php
						for($i = 0;$i<$filas;$i++){
							echo '<tr>';
							for($j = 0;$j<$columnas;$j++){
								echo '<td>'.rand(1,500).'</td>';
							}
							echo '</tr>';
						}
					?>
			</tbody>
		</table>

		<h1>Otra tabla con filtros</h1>
		
		<table>
			<thead>
				<tr>
					<?php
						for($i = 0;$i<$columnas;$i++){
							echo '<th>'.$i.'</th>';
						}
					?>
				</tr>
			</thead>
			<tbody>
				<?php
						for($i = 0;$i<$filas;$i++){
							echo '<tr>';
							for($j = 0;$j<$columnas;$j++){
								echo '<td>'.rand(1,500).'</td>';
							}
							echo '</tr>';
						}
					?>
			</tbody>
		</table>
	</body>
</html>
