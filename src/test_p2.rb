require_relative 'casilla'
require_relative 'civitas_juego'
require_relative 'dado'
require_relative 'diario'
require_relative 'estados_juego'
require_relative 'gestor_estados'
require_relative 'jugador'
require_relative 'mazo_sorpresas'
require_relative 'operaciones_juego'
require_relative 'sorpresa'
require_relative 'tablero'
require_relative 'tipo_casilla'
require_relative 'tipo_sorpresa'
require_relative 'titulo_propiedad'

module Civitas
  class Test_p2
    def self.main
      nombres=Array.new()
      nombres.push("Pablo")
      nombres.push("Sergio")
      nombres.push("Juan")
      nombres.push("Ale")
      juego=Civitas_juego.new(nombres)
      puts 'Juego inicalizado'
      
      juego.jugador_actual.recibe(1000)
      
      
      rank=juego.ranking
      
      for r in rank
        puts "#{r.to_s}"
      end
      
    end
  end
  
end
Civitas::Test_p2.main