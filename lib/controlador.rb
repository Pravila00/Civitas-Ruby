require_relative 'civitas_juego'
require_relative 'operaciones_juego'
require_relative 'respuestas'
require_relative 'jugador'
require_relative 'gestiones_inmobiliarias'
require_relative 'operacion_inmobiliaria'
require_relative 'salidas_carcel'


module Civitas
  class Controlador
    def initialize(juego,vista)
      @juego=juego
      @vista=vista
    end
    
    def juega
      @vista.set_civitas_juego(@juego)
      while(!@juego.final_del_juego)
        @vista.actualizar_vista
        
        @vista.pausa
        
        operacion=@juego.siguiente_paso
        @vista.mostrar_siguiente_operacion(operacion)
        
        if(operacion==Operaciones_juego::PASAR_TURNO)
          puts("\n")
        end
        if(operacion!=Operaciones_juego::PASAR_TURNO)
          @vista.mostrar_eventos
          fin=@juego.final_del_juego
          if(!fin)
            #COMPRAR
            if(operacion==Operaciones_juego::COMPRAR)
              if(@vista.comprar==Respuestas::SI)
                @juego.comprar
              end
              @juego.siguiente_paso_completado(operacion)
            #GESTIONAR
            elsif(operacion==Operaciones_juego::GESTIONAR)
             @vista.gestionar
             gest=@vista.gestion
             lista_gestiones_inmobiliarias=Array.new
             lista_gestiones_inmobiliarias.push(Gestiones_inmobiliarias::VENDER)
             lista_gestiones_inmobiliarias.push(Gestiones_inmobiliarias::HIPOTECAR)
             lista_gestiones_inmobiliarias.push(Gestiones_inmobiliarias::CANCELAR_HIPOTECA)
             lista_gestiones_inmobiliarias.push(Gestiones_inmobiliarias::CONSTRUIR_CASA)
             lista_gestiones_inmobiliarias.push(Gestiones_inmobiliarias::CONSTRUIR_HOTEL)
             lista_gestiones_inmobiliarias.push(Gestiones_inmobiliarias::TERMINAR)
             
             gestion=lista_gestiones_inmobiliarias[gest]
             prop=@vista.propiedad
             op=Operacion_inmobiliaria.new(gestion,prop)
             case op.gestion
             when Gestiones_inmobiliarias::VENDER
               @juego.vender(@vista.propiedad)
               
             when Gestiones_inmobiliarias::HIPOTECAR
               @juego.hipotecar(@vista.propiedad)
               
             when Gestiones_inmobiliarias::CANCELAR_HIPOTECA
               @juego.cancelar_hipoteca(@vista.propiedad)
               
             when Gestiones_inmobiliarias::CONSTRUIR_CASA
               @juego.construir_casa(@vista.propiedad)
               
             when Gestiones_inmobiliarias::CONSTRUIR_HOTEL
               @juego.construir_hotel(@vista.propiedad)
               
             else
               @juego.siguiente_paso_completado(operacion)
             end
              
              
            #SALIR CARCEL
            elsif(operacion==Operaciones_juego::SALIR_CARCEL)
             salida=@vista.salir_carcel
             if(salida==Salidas_carcel::PAGANDO)
               @juego.salir_carcel_pagando
             else
               @juego.salir_carcel_tirando
             end
             @juego.siguiente_paso_completado(operacion)
            end
            
            
          end
        end
        
      end
      
      rank=@juego.ranking
      puts "Se acabo el juego, mostramos ranking"
      for jugador in rank
        puts "#{jugador.to_s}"
      end
    end
    
  end
end
