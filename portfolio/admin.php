<?php
include 'config/db_config.php';

// Determinar qué sección se va a administrar: asignaturas o proyectos (por defecto, asignaturas)
$section = isset($_GET['section']) ? $_GET['section'] : 'asignaturas';

// Variable para mensajes de resultado
$msg = "";

// Procesar formularios enviados (método POST)
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if ($section == 'asignaturas') {
        // Procesar operaciones para asignaturas
        if (isset($_POST['action'])) {
            if ($_POST['action'] == 'add_asignatura') {
                $nombre_asignatura = trim($_POST['nombre_asignatura']);
                $stmt = $conn->prepare("INSERT INTO asignaturas (nombre_asignatura) VALUES (?)");
                $stmt->bind_param("s", $nombre_asignatura);
                if ($stmt->execute()) {
                    $msg = "Asignatura agregada correctamente.";
                } else {
                    $msg = "Error al agregar asignatura: " . $stmt->error;
                }
                $stmt->close();
            } elseif ($_POST['action'] == 'edit_asignatura') {
                $id = intval($_POST['id']);
                $nombre_asignatura = trim($_POST['nombre_asignatura']);
                $stmt = $conn->prepare("UPDATE asignaturas SET nombre_asignatura = ? WHERE id = ?");
                $stmt->bind_param("si", $nombre_asignatura, $id);
                if ($stmt->execute()) {
                    $msg = "Asignatura actualizada correctamente.";
                } else {
                    $msg = "Error al actualizar asignatura: " . $stmt->error;
                }
                $stmt->close();
            }
        }
    } elseif ($section == 'proyectos') {
        // Procesar operaciones para proyectos
        if (isset($_POST['action'])) {
            if ($_POST['action'] == 'add_proyecto') {
                $asignatura_id = intval($_POST['asignatura_id']);
                $nombre = trim($_POST['nombre']);
                $descripcion = trim($_POST['descripcion']);
                $resumen = trim($_POST['resumen']); // Nuevo campo de resumen
                
                // Procesar subida de imagen/video
                $imagen_video_path = "";
                if (isset($_FILES['imagen_video']) && $_FILES['imagen_video']['error'] == 0) {
                    // Validar la extensión del archivo
                    $allowed = ['jpg', 'jpeg', 'png', 'gif'];
                    $file_name = $_FILES['imagen_video']['name'];
                    $file_tmp = $_FILES['imagen_video']['tmp_name'];
                    $file_ext = strtolower(pathinfo($file_name, PATHINFO_EXTENSION));
                    if (in_array($file_ext, $allowed)) {
                        $new_filename = uniqid() . '.' . $file_ext;
                        $destination = 'img/' . $new_filename;
                        if (move_uploaded_file($file_tmp, $destination)) {
                            $imagen_video_path = $destination;
                        }
                    }
                }
                
                // Procesar la URL externa
                $url = trim($_POST['url']);
                
                // Insertar en la base de datos (la tabla debe tener las columnas "resumen" y "url")
                $stmt = $conn->prepare("INSERT INTO proyectos (asignatura_id, nombre, descripcion, resumen, imagen_video, url) VALUES (?, ?, ?, ?, ?, ?)");
                $stmt->bind_param("isssss", $asignatura_id, $nombre, $descripcion, $resumen, $imagen_video_path, $url);
                if ($stmt->execute()) {
                    $msg = "Proyecto agregado correctamente.";
                } else {
                    $msg = "Error al agregar proyecto: " . $stmt->error;
                }
                $stmt->close();
            } elseif ($_POST['action'] == 'edit_proyecto') {
                $id = intval($_POST['id']);
                $asignatura_id = intval($_POST['asignatura_id']);
                $nombre = trim($_POST['nombre']);
                $descripcion = trim($_POST['descripcion']);
                $resumen = trim($_POST['resumen']); // Nuevo campo de resumen
                
                // Verificar si se subió una nueva imagen
                $imagen_video_path = trim($_POST['imagen_video_existing']);
                if (isset($_FILES['imagen_video']) && $_FILES['imagen_video']['error'] == 0) {
                    $allowed = ['jpg', 'jpeg', 'png', 'gif'];
                    $file_name = $_FILES['imagen_video']['name'];
                    $file_tmp = $_FILES['imagen_video']['tmp_name'];
                    $file_ext = strtolower(pathinfo($file_name, PATHINFO_EXTENSION));
                    if (in_array($file_ext, $allowed)) {
                        $new_filename = uniqid() . '.' . $file_ext;
                        $destination = 'uploads/' . $new_filename;
                        if (move_uploaded_file($file_tmp, $destination)) {
                            $imagen_video_path = $destination;
                        }
                    }
                }
                
                // Procesar la URL externa
                $url = trim($_POST['url']);
                
                $stmt = $conn->prepare("UPDATE proyectos SET asignatura_id = ?, nombre = ?, descripcion = ?, resumen = ?, imagen_video = ?, url = ? WHERE id = ?");
                $stmt->bind_param("isssssi", $asignatura_id, $nombre, $descripcion, $resumen, $imagen_video_path, $url, $id);
                if ($stmt->execute()) {
                    $msg = "Proyecto actualizado correctamente.";
                } else {
                    $msg = "Error al actualizar proyecto: " . $stmt->error;
                }
                $stmt->close();
            }
        }
    }
}

// Procesar operaciones de eliminación (vía GET)
if (isset($_GET['delete']) && isset($_GET['id'])) {
    $id = intval($_GET['id']);
    if ($section == 'asignaturas') {
        $stmt = $conn->prepare("DELETE FROM asignaturas WHERE id = ?");
        $stmt->bind_param("i", $id);
        if ($stmt->execute()) {
            $msg = "Asignatura eliminada correctamente.";
        } else {
            $msg = "Error al eliminar asignatura: " . $stmt->error;
        }
        $stmt->close();
    } elseif ($section == 'proyectos') {
        $stmt = $conn->prepare("DELETE FROM proyectos WHERE id = ?");
        $stmt->bind_param("i", $id);
        if ($stmt->execute()) {
            $msg = "Proyecto eliminado correctamente.";
        } else {
            $msg = "Error al eliminar proyecto: " . $stmt->error;
        }
        $stmt->close();
    }
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Admin - Portfolio</title>
    <link rel="stylesheet" href="css/admin.css">
    <?php include 'includes/header.php'; ?>
</head>
<body>
    <h1>Panel de Administración - Portfolio</h1>
    <div class="nav">
        <a href="admin.php?section=asignaturas">Asignaturas</a>
        <a href="admin.php?section=proyectos">Proyectos</a>
        <a href="index.php"><button>Volver al Inicio</button></a>
    </div>
    
    <?php if ($msg): ?>
        <p class="msg"><?php echo $msg; ?></p>
    <?php endif; ?>
    
    <?php if ($section == 'asignaturas'): ?>
        <h2>Gestión de Asignaturas</h2>
        <!-- Formulario para agregar una asignatura -->
        <form method="post" action="admin.php?section=asignaturas">
            <input type="hidden" name="action" value="add_asignatura">
            <label>Nombre de Asignatura:</label>
            <input type="text" name="nombre_asignatura" required>
            <button type="submit">Agregar Asignatura</button>
        </form>
        
        <!-- Listado de Asignaturas -->
        <table>
            <tr>
                <th>ID</th>
                <th>Nombre</th>
                <th>Acciones</th>
            </tr>
            <?php
            $result_asig = $conn->query("SELECT * FROM asignaturas");
            if ($result_asig && $result_asig->num_rows > 0):
                while ($row = $result_asig->fetch_assoc()):
            ?>
                <tr>
                    <td><?php echo $row['id']; ?></td>
                    <td><?php echo $row['nombre_asignatura']; ?></td>
                    <td>
                        <a href="admin.php?section=asignaturas&edit=<?php echo $row['id']; ?>">Editar</a>
                        |
                        <a href="admin.php?section=asignaturas&delete=1&id=<?php echo $row['id']; ?>" onclick="return confirm('¿Seguro que deseas eliminar esta asignatura?');">Eliminar</a>
                    </td>
                </tr>
                <?php if (isset($_GET['edit']) && $_GET['edit'] == $row['id']): ?>
                <tr>
                    <td colspan="3">
                        <form method="post" action="admin.php?section=asignaturas">
                            <input type="hidden" name="action" value="edit_asignatura">
                            <input type="hidden" name="id" value="<?php echo $row['id']; ?>">
                            <label>Nombre de Asignatura:</label>
                            <input type="text" name="nombre_asignatura" value="<?php echo $row['nombre_asignatura']; ?>" required>
                            <button type="submit">Actualizar</button>
                        </form>
                    </td>
                </tr>
                <?php endif; ?>
            <?php endwhile; else: ?>
                <tr><td colspan="3">No hay asignaturas registradas.</td></tr>
            <?php endif; ?>
        </table>
    
    <?php elseif ($section == 'proyectos'): ?>
        <h2>Gestión de Proyectos</h2>
        <!-- Formulario para agregar un proyecto -->
        <!-- Se añade enctype para permitir subir archivos -->
        <form method="post" action="admin.php?section=proyectos" enctype="multipart/form-data">
            <input type="hidden" name="action" value="add_proyecto">
            <label>Nombre del Proyecto:</label>
            <input type="text" name="nombre" required>
            <br>
            <label>Descripción:</label>
            <textarea name="descripcion" required></textarea>
            <br>
            <label>Resumen:</label>
            <textarea name="resumen" required></textarea>
            <br>
            <label>Imagen/Video:</label>
            <input type="file" name="imagen_video" accept="image/*">
            <br>
            <label>URL externa:</label>
            <input type="url" name="url" placeholder="https://ejemplo.com">
            <br>
            <label>Asignatura:</label>
            <select name="asignatura_id" required>
                <option value="">-- Selecciona una asignatura --</option>
                <?php
                $result_asig = $conn->query("SELECT * FROM asignaturas");
                if ($result_asig && $result_asig->num_rows > 0):
                    while ($asig = $result_asig->fetch_assoc()):
                ?>
                        <option value="<?php echo $asig['id']; ?>"><?php echo $asig['nombre_asignatura']; ?></option>
                <?php
                    endwhile;
                endif;
                ?>
            </select>
            <br>
            <button type="submit">Agregar Proyecto</button>
        </form>
        
        <!-- Listado de Proyectos -->
        <table>
            <tr>
                <th>ID</th>
                <th>Nombre</th>
                <th>Asignatura</th>
                <th>Acciones</th>
            </tr>
            <?php
            $query_proy = "SELECT p.*, a.nombre_asignatura FROM proyectos p JOIN asignaturas a ON p.asignatura_id = a.id";
            $result_proy = $conn->query($query_proy);
            if ($result_proy && $result_proy->num_rows > 0):
                while ($row = $result_proy->fetch_assoc()):
            ?>
                <tr>
                    <td><?php echo $row['id']; ?></td>
                    <td><?php echo $row['nombre']; ?></td>
                    <td><?php echo $row['nombre_asignatura']; ?></td>
                    <td>
                        <a href="admin.php?section=proyectos&edit=<?php echo $row['id']; ?>">Editar</a>
                        |
                        <a href="admin.php?section=proyectos&delete=1&id=<?php echo $row['id']; ?>" onclick="return confirm('¿Seguro que deseas eliminar este proyecto?');">Eliminar</a>
                    </td>
                </tr>
                <?php if (isset($_GET['edit']) && $_GET['edit'] == $row['id']): ?>
                <tr>
                    <td colspan="4">
                        <!-- Formulario de edición con enctype para archivos -->
                        <form method="post" action="admin.php?section=proyectos" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="edit_proyecto">
                            <input type="hidden" name="id" value="<?php echo $row['id']; ?>">
                            <!-- Campo oculto para mantener la imagen actual si no se sube una nueva -->
                            <input type="hidden" name="imagen_video_existing" value="<?php echo $row['imagen_video']; ?>">
                            <label>Nombre del Proyecto:</label>
                            <input type="text" name="nombre" value="<?php echo $row['nombre']; ?>" required>
                            <br>
                            <label>Descripción:</label>
                            <textarea name="descripcion" required><?php echo $row['descripcion']; ?></textarea>
                            <br>
                            <label>Resumen:</label>
                            <textarea name="resumen" required><?php echo $row['resumen']; ?></textarea>
                            <br>
                            <label>Imagen/Video:</label>
                            <input type="file" name="imagen_video" accept="image/*">
                            <br>
                            <label>URL externa:</label>
                            <input type="url" name="url" value="<?php echo $row['url']; ?>" placeholder="https://ejemplo.com">
                            <br>
                            <label>Asignatura:</label>
                            <select name="asignatura_id" required>
                                <option value="">-- Selecciona una asignatura --</option>
                                <?php
                                $result_asig2 = $conn->query("SELECT * FROM asignaturas");
                                if ($result_asig2 && $result_asig2->num_rows > 0):
                                    while ($asig = $result_asig2->fetch_assoc()):
                                ?>
                                        <option value="<?php echo $asig['id']; ?>" <?php if($asig['id'] == $row['asignatura_id']) echo 'selected'; ?>><?php echo $asig['nombre_asignatura']; ?></option>
                                <?php
                                    endwhile;
                                endif;
                                ?>
                            </select>
                            <br>
                            <button type="submit">Actualizar Proyecto</button>
                        </form>
                    </td>
                </tr>
                <?php endif; ?>
            <?php endwhile; else: ?>
                <tr><td colspan="4">No hay proyectos registrados.</td></tr>
            <?php endif; ?>
        </table>
    <?php endif; ?>
</body>
</html>

<?php
$conn->close();
?>
<?php include 'includes/footer.php'; ?>
