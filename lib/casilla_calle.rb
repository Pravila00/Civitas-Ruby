require_relative 'titulo_propiedad'

module Civitas
  class Casilla_calle < Casilla
    #Constructor
    def initialize(titulo)
      super(titulo.nombre)
      @titulo=titulo
    end
    
    #Consultor de titulo
    def titulo_propiedad
      @titulo
    end
    
    def recibe_jugador(iactual,todos)
      if(jugador_correcto(iactual,todos))
        informe(iactual,todos)
        jugador=todos.at(iactual)
        if(!@titulo.tiene_propietario)
          jugador.puede_comprar_casilla
        else
          @titulo.tramitar_alquiler(jugador)
        end
      end
    end
    
    def to_s
      cadena=super
      cadena+="Tipo: CALLE| \n#{@titulo.to_s}"
    end
    
  end
end
