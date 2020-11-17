# encoding:utf-8
require_relative 'dado.rb'
require_relative 'diario.rb'
require_relative 'tablero.rb'
require_relative 'tipo_casilla.rb'
require_relative 'tipo_sorpresa.rb'
require_relative 'casilla.rb'
require_relative 'mazo_sorpresas.rb'

module Civitas
  class TestP1
    def self.main
      #Tarea1
      empieza=Array.new(4){0}
      for i in (0..99)
        empieza[Dado.instance.quien_empieza(4)]+=1
      end
      for j in (0..3)
        puts "Jugador #{j}: #{empieza[j]}"
      end
      
      #Tarea 2
      Dado.instance.debug=false
      puts "Modo debug del dado desactivado"
      for z in(0..9)
        puts "#{Dado.instance.tirar}"
      end
      
      Dado.instance.debug=true
      puts "Modo debug del dado activado"
      for t in(0..9)
        puts "#{Dado.instance.tirar}"
      end
      
      #Tarea 3
      puts "Ultimo resultado: #{Dado.instance.ultimo_resultado}"
      puts "Salgo de la carcel: #{Dado.instance.salgo_de_la_carcel}"
      
      #Tarea 4
      puts Tipo_casilla::CALLE
      puts Tipo_sorpresa::IRCARCEL
      
      #Tarea 5
      mazo1=MazoSorpresas.new
      mazo2=MazoSorpresas.new_debug(true)
      sorpresa=Sorpresa.new
      mazo1.al_mazo(sorpresa)
      mazo1.inhabilitar_carta_especial(sorpresa)
      mazo1.habilitar_carta_especial(sorpresa)
      
      #Tarea 6
      while(Diario.instance.eventos_pendientes)
        Diario.instance.leer_evento
      end
      Diario.instance.ocurre_evento("Prueba de diario")
      Diario.instance.leer_evento
      
      #Tarea 7
      tablero=Tablero.new(5)
      puts "Por salida: #{tablero.por_salida} "
      tablero.añade_casilla(Casilla.new(Casilla.new("c1")))
      tablero.añade_juez
      puts "Calculo de tirada : #{tablero.calcular_tirada(3, 1)}"
      
      
      
    end
  end
end

Civitas::TestP1.main
