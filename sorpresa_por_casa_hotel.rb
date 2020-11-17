module Civitas
  class Sorpresa_por_casa_hotel < Sorpresa
    def initialize(texto,valor)
      super(texto)
      @valor=valor
    end
    
    def aplicar_a_jugador(actual,todos)
      if(jugador_correcto(actual,todos))
        jugador=todos.at(actual)
        informe(actual,todos)
        jugador.modificar_saldo(@valor*jugador.cantidad_casas_hoteles)
      end
    end
    
    def to_s
      cadena="Sorpresa PorCasaHotel| #{texto}| Valor: #{@valor}"
    end
    
    public_class_method :new
  end
end
