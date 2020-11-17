module Civitas
  class Sorpresa_ir_casilla < Sorpresa
    def initialize(texto,valor,tablero)
      super(texto)
      @valor=valor
      @tablero=tablero
    end
    
    def aplicar_a_jugador(actual,todos)
      informe(actual,todos)
      casilla=todos.at(actual).num_casilla_actual
      tirada=@tablero.calcular_tirada(casilla,@valor)
      nueva_pos=@tablero.nueva_posicion(casilla,tirada)
      todos.at(actual).mover_a_casilla(nueva_pos)
      @tablero.casilla(@valor).recibe_jugador(actual,todos)
    end
    
    def to_s
      cadena="Sorpresa Ir Casilla| #{texto}| Valor: #{@valor}"
    end
    
    public_class_method :new
  end
end
