module Civitas
  class Sorpresa_por_jugador < Sorpresa
    def initialize(texto,valor)
      super(texto)
      @valor=valor
    end
    
    def aplicar_a_jugador(actual,todos)
      if(jugador_correcto(actual,todos))
        informe(actual,todos)
        s=Sorpresa_pagar_cobrar.new("Pagar",@valor*(-1))
        for i in (0..todos.length)
          if(i!=actual)
            s.aplicar_a_jugador(i,todos)
          end
        end
        s2=Sorpresa_pagar_cobrar.new("Cobrar",@valor*(todos.length -1 ))
        s2.aplicar_a_jugador(actual,todos)
      end
    end
    
    def to_s
      "Sorpresa Por Jugador| #{texto}| Valor: #{@valor}"
    end
    
    public_class_method :new
  end
end
