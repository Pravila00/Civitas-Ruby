# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class Sorpresa_pagar_cobrar < Sorpresa
    def initialize(texto,valor)
      super(texto)
      @valor=valor
    end
    
    def aplicar_a_jugador(actual,todos)
      jugador=todos.at(actual)
      if(jugador_correcto(actual,todos))
        informe(actual,todos)
        jugador.modificar_saldo(@valor)
      end
    end
    
    def to_s
      cadena="Sorpresa Pagar Cobrar| Valor: #{@valor}"
      cadena
    end
    
    public_class_method :new
  end
end
