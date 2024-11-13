/*/////////////////////////////////// DECLARACIONES INICIALES //////////////////////////////////////*/
      
      // Declaro variables globales en uso en todo el juego /////////////////////////////////////////////////////////////
      
      var gravedad = 1;                                                           // La variable de gravedad define como de rápido cae el personaje
      var salto = -16;
      
      var desfase_global_x = 0;                                                     // Inicialmente el desfase es de 0
      
      var jugador = new Jugador();                                                  // Aquí instancio una única copia del jugador humano
      
      var misnpcs = [];                                                             // Aquí instancio a los npc en un array de 50 elementos
      var balas = [];
      var numeronpc = 12;                                                           // defino el numero de npc
      for(let i = 0;i<numeronpc;i++){                                               // Recorro el array
        misnpcs[i] = new Npc();                                                     // PAra cada elemento, meto una nueva instancia de Npc
      }
      
      /*/////////////////////////////////// DECLARACIONES INICIALES //////////////////////////////////////*/
