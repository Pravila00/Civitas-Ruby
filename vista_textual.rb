#encoding:utf-8
require_relative 'operaciones_juego'
require_relative 'diario'
require_relative 'jugador'
require_relative 'titulo_propiedad'
require_relative 'civitas_juego'
require_relative 'salidas_carcel'
require_relative 'respuestas'
require_relative 'casilla'


require 'io/console'

module Civitas

  class Vista_textual
    @@separador="====================="
    
    def initialize
      @i_gestion=-1
      @i_propiedad=-1
    end
    
    def mostrar_estado(estado)
      puts estado
    end

    
    def pausa
      print "Pulsa una tecla"
      STDIN.getch
      print "\n"
    end

    def lee_entero(max,msg1,msg2)
      ok = false
      begin
        print msg1
        cadena = gets.chomp
        begin
          if (cadena =~ /\A\d+\Z/)
            numero = cadena.to_i
            ok = true
          else
            raise IOError
          end
        rescue IOError
          puts msg2
        end
        if (ok)
          if (numero >= max)
            ok = false
          end
        end
      end while (!ok)

      return numero
    end



    def menu(titulo,lista)
      tab = "  "
      puts titulo
      index = 0
      lista.each { |l|
        puts tab+index.to_s+"-"+l
        index += 1
      }

      opcion = lee_entero(lista.length,
                          "\n"+tab+"Elige una opción: ",
                          tab+"Valor erróneo")
      return opcion
    end

    
    def comprar
      lista_respuestas=[Respuestas::NO,Respuestas::SI]
      opcion=menu("Desea comprar la casilla?",["No comprar","Comprar"])
      lista_respuestas[opcion]
    end

    def gestionar
      opcion=menu("Elige la gestion inmobiliaria",["Vender","Hipotecar",
        "Cancelar hipoteca","Construir casa","Construir Hotel","Terminar"])
      @i_gestion=opcion
      #Si no se ha escogido terminar
      if(opcion!=5)
        nombres=Array.new
        for propiedad in @juego_model.jugador_actual.propiedades
          nombres.push(propiedad.nombre)
        end
        @i_propiedad=menu("Elige una de tus propiedades",nombres)
      end
    end

    def gestion
      @i_gestion
    end

    def propiedad
      @i_propiedad
    end

    def mostrar_siguiente_operacion(operacion)
      puts("Siguiente operacion: #{operacion.to_s}")
    end

    def mostrar_eventos
      while Diario.instance.eventos_pendientes
        Diario.instance.leer_evento
      end
      
    end

    def set_civitas_juego(civitas)
        @juego_model=civitas
    end

    def actualizar_vista
      jugador=@juego_model.jugador_actual
      casilla=@juego_model.casilla_actual
      propiedades=Array.new
      propiedades=jugador.propiedades
      
      #Mostramos jugador
      puts(@@separador)
      puts("JUGADOR")
      puts("#{jugador.to_s}\n")
      
      #Mostramos sus propiedades
      puts("PROPIEDADES")
      for propiedad in propiedades
        puts(propiedad.to_s)
      end
      puts("\n")
      
      #Mostramos su casilla
      puts("CASILLA ACTUAL")
      puts(casilla.to_s)
      puts("#{@@separador}\n")
      
    end
    
    def salir_carcel
      lista_salidas_carcel=[Salidas_carcel::PAGANDO,Salidas_carcel::TIRANDO]
      opcion=menu("Elige la forma para intentar salir de la carcel",
      ["Pagando","Tirando"])
      lista_salidas_carcel[opcion]
    end

    
  end

end
