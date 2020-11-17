require_relative 'jugador_especulador'

module Civitas
  class Sorpresa_jugador_especulador < Sorpresa
    def initialize(texto,fianza)
      super(texto)
      @fianza=fianza
    end
    
    def aplicar_a_jugador(actual,todos)
      if(jugador_correcto(actual,todos))
        informe(actual,todos)
        jugador=Jugador_especulador.nuevo_especulador(todos.at(actual),@fianza)
        todos[actual]=jugador
      end
    end
    
    def to_s
      cadena="Sorpresa JugadorEspeculador| #{texto}| Fianza: #{@fianza}"
      cadena
    end
    
    public_class_method :new
  end
end
