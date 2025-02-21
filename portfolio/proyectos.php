<?php
include 'config/db_config.php';
include 'includes/header.php';

// Determinar si se aplicó un filtro por asignatura mediante GET (por defecto, "Todos")
$filter = isset($_GET['asignatura']) ? $_GET['asignatura'] : 'Todos';

if($filter !== 'Todos'){
    // Consulta preparada para obtener proyectos de una asignatura en específico
    $stmt = $conn->prepare("SELECT p.*, a.nombre_asignatura FROM proyectos p JOIN asignaturas a ON p.asignatura_id = a.id WHERE a.nombre_asignatura = ?");
    $stmt->bind_param("s", $filter);
    $stmt->execute();
    $result = $stmt->get_result();
    $stmt->close();
} else {
    // Consulta para obtener todos los proyectos
    $query = "SELECT p.*, a.nombre_asignatura FROM proyectos p JOIN asignaturas a ON p.asignatura_id = a.id";
    $result = $conn->query($query);
}
?>

<main>
  <h1>Proyectos</h1>
  
  <!-- Botones de filtro por asignatura -->
  <div>
    <a href="proyectos.php?asignatura=Todos"><button>Todos</button></a>
    <a href="proyectos.php?asignatura=Acceso a datos"><button>Acceso a datos</button></a>
    <a href="proyectos.php?asignatura=Desarrollo de interfaces"><button>Desarrollo de interfaces</button></a>
    <a href="proyectos.php?asignatura=Programación de servicios y procesos"><button>Programación de servicios y procesos</button></a>
    <a href="proyectos.php?asignatura=Programación multimedia y dispositivos móviles"><button>Programación multimedia y dispositivos móviles</button></a>
    <a href="proyectos.php?asignatura=Sistemas de gestión empresarial"><button>Sistemas de gestión empresarial</button></a>
  </div>

  <div id="projects-container">
    <?php if ($result && $result->num_rows > 0): ?>
      <?php while ($row = $result->fetch_assoc()): ?>
        <div class="project-item" data-asignatura="<?php echo $row['nombre_asignatura']; ?>">
          <h2><?php echo $row['nombre']; ?></h2>
          <!--<p><?php echo $row['descripcion']; ?></p>-->
          <?php if ($row['imagen_video']): ?>
            <img src="<?php echo $row['imagen_video']; ?>" alt="<?php echo $row['nombre']; ?>" style="max-width:200px;">
          <?php endif; ?>
          <p><a href="proyecto_detalle.php?id=<?php echo $row['id']; ?>">Ver más</a></p>
        </div>
      <?php endwhile; ?>
    <?php else: ?>
      <p>No hay proyectos disponibles.</p>
    <?php endif; ?>
  </div>
</main>

<?php include 'includes/footer.php'; ?>
<script src="js/funciones.js"></script>
