require_relative 'sorpresa'
require_relative 'mazo_sorpresas'

module Civitas
  class Casilla_sorpresa < Casilla
    def initialize(nombre,mazo)
      super(nombre)
      @mazo=mazo
    end
    
    def recibe_jugador(iactual,todos)
      if(jugador_correcto(iactual,todos))
        @sorpresa=@mazo.siguiente
        informe(iactual,todos)
        @sorpresa.aplicar_a_jugador(iactual,todos)
      end
    end
    
    def to_s
      cadena=super
      cadena+="Tipo: SOPRESA| #{@sorpresa.to_s}"
    end
  end
end
