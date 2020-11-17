module Civitas
  class Casilla_impuesto < Casilla
    #Constructor
    def initialize(nombre,importe)
      super(nombre)
      @importe=importe
    end
    
    #Redefinimos recibe_jugador
    def recibe_jugador(actual,todos)
      if(jugador_correcto(actual,todos))
        informe(actual,todos)
        todos.at(actual).paga_impuesto(@importe)
      end
    end
    
    #Metodo to_s
    def to_s
      cadena=super
      cadena+="Tipo: IMPUESTO| Importe #{@importe}"
    end
  end
end
