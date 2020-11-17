module Civitas
  class Sorpresa_ir_carcel < Sorpresa
    def initialize(texto,tablero)
      super(texto)
      @tablero=tablero
    end
    
    def aplicar_a_jugador(actual,todos)
      if(jugador_correcto(actual,todos))
        informe(actual,todos)
        todos.at(actual).encarcelar(@tablero.carcel)
      end
    end
    
    def to_s
      cadena="Sorpresa Ir Carcel| #{texto}"
      cadena
    end
    
    public_class_method :new
  end
end
