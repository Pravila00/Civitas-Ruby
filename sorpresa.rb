module Civitas
  class Sorpresa
    def initialize(texto)
      @texto=texto
    end
    
    def informe(actual,todos)
      Diario.instance.ocurre_evento("Se aplica una sorpresa a #{todos.at(actual).nombre}")
    end
    
    def init
      @valor=-1
      @mazo=nil
      @tablero=nil
    end
    
    def jugador_correcto(actual,todos)
      actual<todos.length && actual>=0
    end
    
    def texto
      @texto
    end
      
    private :informe
      
    #LA CLASE NO ES INSTANCIABLE
    private_class_method  :new
  end
  
end
