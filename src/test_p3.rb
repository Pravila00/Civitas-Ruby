require_relative 'vista_textual'
require_relative 'civitas_juego'
require_relative 'dado'
require_relative 'controlador'

module Civitas
  class Test_p3
    def self.main
      #Creamos una vista textual
      vista=Vista_textual.new
      
      #Creamos una instancia de Civitas_juegp
      nombres=Array.new
      nombres.push("Pepe")
      nombres.push("Pablo")
      nombres.push("Juan")
      nombres.push("Sergio")
      
      juego=Civitas_juego.new(nombres)
      
      vista.set_civitas_juego(juego)
      
      #Modo debug del dado
      Dado.instance.debug=false
      
      #Creamos una instancia del controlador
      controlador=Controlador.new(juego,vista)
      controlador.juega
    end
  end
  Test_p3.main
end
