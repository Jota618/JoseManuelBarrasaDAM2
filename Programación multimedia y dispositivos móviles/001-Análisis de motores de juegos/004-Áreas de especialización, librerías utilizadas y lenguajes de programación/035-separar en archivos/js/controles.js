// Controles para mover al jugador con las teclas del teclado ////////////////////////////////
      
      document.onkeydown = function(e){
      console.log(e)
        if(e.key == "ArrowUp" && jugador.cayendo == false){
          jugador.y -= 5;
          jugador.vy = salto;
          }
        if(e.key == "ArrowDown"){jugador.y += 5}
        if(e.key == "ArrowLeft"){jugador.x -= 5;jugador.direccion = "izquierda";}         // Esto es lo que ocurre cuando el jugador pulsa la flecha izquierda
        if(e.key == "ArrowRight"){jugador.x += 5;jugador.direccion = "derecha"}           // Esto es lo que ocurre cuando el jugador pulsa la flecha derecha
        if(e.keyCode == 32){console.log("ok disparo");balas.push(new Bala());}          // Esto es lo que ocurre cuando pulso la barra espaciadora
      }
      
      // Controles para mover al jugador con las teclas del teclado ////////////////////////////////
