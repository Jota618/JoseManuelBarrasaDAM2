class Bala{
        constructor(){
          this.x = jugador.x;                               // La posición x inicial de la bala es la misma posición del jugador
          this.y = jugador.y;                               // La posición y inicial de la bala es la mism posición del jugador
          this.vx = 10;                                     // A la bala se le da una velocidad inicial
          if(jugador.direccion == "izquierda"){             // Si el jugador va hacia la izquierda
            this.direccion = -1                             // En ese caso la velociad de la bala es negativa
          }else{                                            // Si el personaje va hacia la derecha
            this.direccion = 1                              // En ese caso la velocidad es positiva
          }
        }
        mueve(){                                            // Método que mueve la bala
          this.x += this.direccion*this.vx                  // Actualiza su posición
        }
        dibuja(){                                           // Método que dibuja la bala
          contexto.beginPath()
          contexto.arc(this.x-desfase_global_x,this.y,10,0,Math.PI*2)
          contexto.fill()
        }
      }
