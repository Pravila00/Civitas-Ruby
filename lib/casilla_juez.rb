module Civitas
  class Casilla_juez < Casilla
    def initialize(nombre, casilla_carcel)
      super(nombre)
      @@carcel=casilla_carcel
    end
    
    def recibe_jugador(iactual,todos)
      if(jugador_correcto(iactual,todos))
        informe(iactual,todos)
        todos.at(iactual).encarcelar(@@carcel)
      end
    end
    
    def to_s
      cadena=super
      cadena+="Tipo: JUEZ| Carcel: #{@@carcel}"
    end
  end
end
