require_relative 'jugador'
require_relative 'titulo_propiedad'
require_relative 'sorpresa_jugador_especulador'
require_relative 'civitas_juego'

module Civitas
  class TestP4
    def self.main
      #Creamos jugador
      jugador=Jugador.new("Pablo")
      todos=Array.new
      todos.push(jugador)
      
      #Le asociamos una propiedad
      titulo=Titulo_propiedad.new("Calle Gibraltar",55,4,400,400,550)
      jugador.propiedades.push(titulo)
      puts jugador.inspect
      
      #Lo convertimos en jugador especulador
      sorpresa=Sorpresa_jugador_especulador.new("Pasas a jugador especulador",1000)
      sorpresa.aplicar_a_jugador(0,todos)
      
      #Lo mostramos
      puts todos.at(0).inspect
      puts todos.at(0).is_especulador
      
      juego=Civitas_juego.new(["Pablo"])
      #sorpresa.aplicar_a_jugador(0,juego.)
      #juego.avanza_jugador
    end
  end
  TestP4.main
end
