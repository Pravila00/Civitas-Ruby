module Civitas
  class Operacion_inmobiliaria
    def initialize(gest,ip)
      @num_propiedad=ip
      @gestion=gest
    end
    
    def num_propiedad
      @num_propiedad
    end
    
    def gestion
      @gestion
    end
  end
end
