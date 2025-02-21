function filterProjects(asignatura) {
    var items = document.querySelectorAll('.project-item');
    items.forEach(function(item) {
      if (asignatura === 'Todos' || item.getAttribute('data-asignatura') === asignatura) {
        item.style.display = 'block';
      } else {
        item.style.display = 'none';
      }
    });
  }
  