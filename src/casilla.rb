module Civitas
  class Casilla
    def initialize(nombre)
      @nombre=nombre
    end
    
    def nombre
      @nombre
    end
    
    def informe(iactual,todos)
      evento="El jugador #{todos.at(iactual).nombre} ha caido en la casilla #{to_s}"
      Diario.instance.ocurre_evento(evento)
    end
    
    def jugador_correcto(iactual,todos)
      iactual<todos.length && iactual>=0
    end
    
    def recibe_jugador(iactual,todos)
      informe(iactual,todos)
    end
    
    def to_s
      "Casilla: #{@nombre}| "
    end
    
    private :informe
  end
end
