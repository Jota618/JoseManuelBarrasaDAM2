var temporizador = setTimeout("bucle()",1000);
      
      
      function bucle(){
        if(jugador.x+desfase_global_x > 400){                                       // Si el jugador se acerca demasiado al limite de la derecha
          desfase_global_x += 2                                                     // Aumenta el desfase lo que quiere decir que todo se mueve hacia la izquierda
        }
        if(jugador.x+desfase_global_x < 120){                                       // Si el jugador se acerca demasiado al limite de la derecha
          desfase_global_x -=2                                                      // Aumenta el desfase en lado contrario
        }
        
        contexto.clearRect(0,0,512,512);                                            // Limpio el lienzo 1
        contexto2.clearRect(0,0,512,512);                                           // Limpio el lienzo 2
        
        contextoplataformas.clearRect(0,0,512,512);                                 // Limpio el contexto de las plataformas
        
        contextoplataformas.drawImage(imagennivel,0-desfase_global_x,0,2048,512)    // porque a continuación pinto las plataformas actualizadas de espacio
        
        for(let i = 0;i<misnpcs.length;i++){                                        // A continuación movemos a todos los npc llamando a sus métodos
          misnpcs[i].mueve()
          misnpcs[i].rebota();
          misnpcs[i].dibuja();
        }
        
        for(let i = 0;i<balas.length;i++){                                          // A continuación movemos a todas las balas llamando a sus métodos
          balas[i].mueve()                                                          // PAra cada una de las balas, movemos la bala
          balas[i].dibuja();                                                        // Dibujamos la bala
        }
        
        // Voy a comprobar si ALGUNA de las balas colisiona con ALGUNO de los npc
        // Clásica estructura de doble bucle for
        for(let i = 0;i<balas.length;i++){                                          // Para cada una de las balas
          for(let j = 0;j<misnpcs.length;j++){                                      // Y a la vez para cada uno de los npc
            if(calculateDistance(                   
              balas[i].x, 
              balas[i].y, 
              misnpcs[j].x, 
              misnpcs[j].y
            )  < 20){                                                               // Si la distancia es menor que 20 pixeles                                          
              misnpcs.splice(j,1)                                                   // Elimino un npc del array de npcs
            }
          }
        }
        
        jugador.mueve();                                              
        jugador.dibuja();                                                           // Dibujamos al jugador 1
        
        var datos = contexto.getImageData(jugador.x,jugador.y,1,1).data;            // Mediante la siguiente linea soy capaz de obtener un array con los componentes de color de un pixel
        var alpha = datos[3];                                                       // El índice 3 es la transparencia
        if(alpha == 255){
          window.location = window.location                                         // Esto es recargar la página, lo que viene a querer decir que has perdido
        }
        clearTimeout(temporizador);
        temporizador = setTimeout("bucle()",30);
      }
