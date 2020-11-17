require 'singleton'

module Civitas
  class Dado
    include Singleton
    attr_reader  :ultimo_resultado
    
    @@Salida_carcel=5
    
    def initialize
      @random=Random.new
      @ultimo_resultado=0
      @debug=false
    end
    
    def tirar
      tirada=1
      if !@debug
        tirada=@random.rand(1..6)
      end
      @ultimo_resultado=tirada
      tirada
    end
    
    def salgo_de_la_carcel
      salgo=false
      if tirar >= @@Salida_carcel
        salgo=true
      end
      salgo
    end
    
    def quien_empieza(n)
      @random.rand(n)
    end
    
    def debug=(d)
      @debug=d
      if @debug
        Diario.instance.ocurre_evento("Se ha activado el modo debug del dado")
      else
        Diario.instance.ocurre_evento("Se he desactivado el modo debug del dado")
      end
    end
  end
end
