module Civitas
  class Jugador_especulador < Jugador
    @@FactorEspeculador=2
    
    #Constructor
    def initialize(fianza)
      @fianza=fianza
    end
    
    def self.nuevo_especulador(jugador,fianza)
      especulador=self.new(fianza)
      especulador.copia(jugador)
      tam=jugador.propiedades.size
      for i in (0..tam-1) do
        jugador.propiedades.at(i).actualiza_propietario_por_conversion(especulador)
      end
      especulador
    end

    def debe_ser_encarcelado
      debe_serlo=super
      if(debe_serlo && @saldo>=@fianza)
        debe_serlo=false
        paga(@fianza)
      end
    end
    
    def paga_impuesto(cantidad)
      super(cantidad/2)
    end
    
    def is_especulador
      true
    end
    
    def self.Casas_max
      super * @@FactorEspeculador
    end
    
    def self.Hoteles_max
      super * @@FactorEspeculador
    end
    
    def to_s
      cadena=super
      cadena+="| JugadorEspeculador"
      cadena
    end
  end
end
