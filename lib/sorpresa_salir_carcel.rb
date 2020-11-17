module Civitas
  class Sorpresa_salir_carcel < Sorpresa
    def initialize(texto,mazo)
      super(texto)
      @mazo=mazo
    end
    
    def aplicar_a_jugador(actual,todos)
      if(jugador_correcto(actual,todos))
        informe(actual,todos)
        lo_tiene=false
        for jugador in todos do
          if(jugador.tiene_salvoconducto)
            lo_tiene=true
          end
        end
        if(!lo_tiene)
          todos.at(actual).obtener_salvoconducto(self)
          salir_del_mazo
        end
      end
    end
    
    def salir_del_mazo
      @mazo.inhabilitar_carta_especial(self)
    end
    
    def usada
      @mazo.habilitar_carta_especial(self)
    end
    
    def to_s
      cadena="Sorpresa Salir Carcel| #{texto}"
      cadena
    end
    
    public_class_method :new
  end
end
