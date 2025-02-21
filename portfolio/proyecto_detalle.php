<?php
include 'config/db_config.php';
include 'includes/header.php';

if (isset($_GET['id'])) {
    $id = intval($_GET['id']);
    // Consulta preparada que une proyectos y asignaturas
    $stmt = $conn->prepare("SELECT p.*, a.nombre_asignatura FROM proyectos p JOIN asignaturas a ON p.asignatura_id = a.id WHERE p.id = ?");
    $stmt->bind_param("i", $id);
    $stmt->execute();
    $result = $stmt->get_result();
    if ($result->num_rows > 0) {
      $project = $result->fetch_assoc();
    } else {
      echo "<p>Proyecto no encontrado.</p>";
      exit;
    }
    $stmt->close();
} else {
    echo "<p>ID de proyecto no proporcionado.</p>";
    exit;
}
?>

<main>
  <h1><?php echo $project['nombre']; ?></h1>
  <?php if ($project['imagen_video']): ?>
    <img src="<?php echo $project['imagen_video']; ?>" alt="<?php echo $project['nombre']; ?>" style="max-width:300px;">
  <p><?php echo $project['descripcion']; ?></p>
  <p><?php echo $project['resumen']; ?></p>
  <?php endif; ?>
  <p><strong>Asignatura:</strong> <?php echo $project['nombre_asignatura']; ?></p>
  <?php if ($project['url']): ?>
    <p><strong>URL:</strong> <a href="<?php echo $project['url']; ?>" target="_blank"><?php echo $project['url']; ?></a></p>
  <?php endif; ?>
  <p><a href="proyectos.php">Volver a Proyectos</a></p>
</main>

<?php include 'includes/footer.php'; ?>
