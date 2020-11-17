require_relative 'sorpresa'

module Civitas
  class Mazo_sorpresas
    def init
      @sorpresas=Array.new
      @cartas_especiales=Array.new
      @barajada=false
      @usadas=0
      @ultima_sorpresa=nil
    end
    
    def initialize
      init
      @debug=false
    end
    
    def self.new_debug(d)
      new
      @debug=d
      if @debug
        Diario.instance.ocurre_evento("Modo debug de Mazo Sorpresas activado")
      end
    end
    
    def al_mazo(s)
      if !@barajada 
        @sorpresas.push(s)
      end
    end
    
    def siguiente
      if (!@barajada || @usadas == @sorpresas.length) && !@debug
        @sorpresas.shuffle
        @usadas=0
        @barajada=true
      end
      @usadas+=1
      s=@sorpresas.at(0)
      @sorpresas.delete_at(0)
      @sorpresas.push(s)
      @ultima_sorpresa=s
      @ultima_sorpresa  
    end
    
    def inhabilitar_carta_especial(sorpresa)
      if @sorpresas.include?(sorpresa)
        @sorpresas.delete(sorpresa)
        @cartas_especiales.push(sorpresa)
        Diario.instance.ocurre_evento("Se ha inhabilitado una carta especial")
      end
    end
    
    def habilitar_carta_especial(sorpresa)
      if @cartas_especiales.include?(sorpresa)
        @cartas_especiales.delete(sorpresa)
        @sorpresas.push(sorpresa)
        Diario.instance.ocurre_evento("Se ha habilitado una carta especial")
      end
    end
    
    
  end
end
