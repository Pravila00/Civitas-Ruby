# encoding:utf-8

require_relative 'titulo_propiedad'
require_relative 'sorpresa'
require_relative 'diario'

module Civitas
  class Jugador
    include Comparable
    

    @@Casas_max=4
    @@Casas_por_hotel=4
    @@Hoteles_max=4
    @@Paso_por_salida=1000
    @@Precio_libertad=200
    @@Saldo_inicial=7500

    def initialize(n)
      @encarcelado=false
      @nombre=n
      @num_casilla_actual=0
      @puede_comprar=true
      @saldo=@@Saldo_inicial
      @propiedades=Array.new
      @salvoconducto=nil
    end


    def self.new_copia(otro)  
      jugador=new(otro.nombre)
      jugador.copia(otro)
      jugador
    end
    
    def copia(otro)
      @nombre=otro.nombre
      @encarcelado=otro.is_encarcelado
      @num_casilla_actual=otro.num_casilla_actual
      @puede_comprar=otro.puede_comprar
      @saldo=otro.saldo
      @propiedades=otro.propiedades
      @salvoconducto=otro.salvoconducto
    end

    def cancelar_hipoteca(ip)
      result=false
      if(@encarcelado)
        return result
      end
      if(existe_la_propiedad(ip))
        propiedad=@propiedades.at(ip)
        cantidad=propiedad.importe_cancelar_hipoteca
        puedo_gastar=puedo_gastar(cantidad)
        if(puedo_gastar)
          result=propiedad.cancelar_hipoteca(self)
        end
        if(result)
          Diario.instance.ocurre_evento("El jugador #{@nombre} cancelar la hipoteca
            de la propiedad #{ip}")
        end
      end
    end

    def cantidad_casas_hoteles
      c=0
      for titulo in @titulos
        c+=titulo.num_casas
        c+=titulo.num_hoteles
      end
      c
    end


    def <=>(otro)
      @saldo<=>otro.saldo
    end
    
    def is_especulador
      false
    end

    def comprar(titulo)
      result=false
      if(@encarcelado)
        return result
      end
      if(@puede_comprar)
        precio=titulo.precio_compra
        if(puedo_gastar(precio))
          result=titulo.comprar(self)
        end
        if(result)
          @propiedades.push(titulo)
          Diario.instance.ocurre_evento("El jugador #{@nombre} compra la propiedad #{titulo.to_s}")
        end
        @puede_comprar=false
      end
      result
    end

    def construir_casa(ip)
      result=false
      if(@encarcelado)
        return result
      end
      if(!@encarcelado)
        existe=existe_la_propiedad(ip)
        if(existe)
          propiedad=@propiedades.at(ip)
          puedo_edificar_casa=puedo_edificar_casa(propiedad)
          if(puedo_edificar_casa)
            result=propiedad.construir_casa(self)
            if(result)
              Diario.instance.ocurre_evento("El jugador #{@nombre} construye en la propiedad #{ip}")
            end
          end
        end
      end
      
    end

    def construir_hotel(ip)
      result=false
      if(@encarcelado)
        return result
      end
      if(existe_la_propiedad(ip))
        propiedad=@propiedades.at(ip)
        puedo_edificar_hotel=puedo_edificar_hotel(propiedad)
        if(puedo_edificar_hotel)
          result=propiedad.construir_hotel(self)
          propiedad.derruir_casas(@@Casas_por_hotel,self)
          Diario.instance.ocurre_evento("El jugador #{@nombre} construye en la propiedad #{ip}")
        end
      end
      result
    end
    
    def especulador=(valor)
      @especulador=valor
    end

    def debe_ser_encarcelado
      resultado=false
      if(@encarcelado)
        resultado=false
      elsif(!tiene_salvoconducto)
        resultado=true
      elsif(tiene_salvoconducto)
        perder_salvoconducto
        evento="El jugador #{@nombre} usa el salvoconducto y sale de la carcel"
        Diario.instance.ocurre_evento(evento)
      end
      resultado
    end

    def en_bancarrota
      @saldo<0
    end

    def encarcelar(num_casilla_carcel)
      if(debe_ser_encarcelado)
        mover_a_casilla(num_casilla_carcel)
        @encarcelado=true
        evento="El jugador #{@nombre} ha sido encarcelado"
        Diario.instance.ocurre_evento(evento)
      end
      @encarcelado
    end

    def existe_la_propiedad(ip)
       @propiedades.at(ip) != nil
    end

    def self.Casas_max
      @@Casas_max
    end

    def self.Casas_por_hotel
      @@Casas_por_hotel
    end

    def self.Hoteles_max
      @@Hoteles_max
    end

    def nombre
      @nombre
    end

    def num_casilla_actual
      @num_casilla_actual
    end

    def self.Precio_libertad
      @@Precio_libertad
    end

    def self.Premio_paso_salida
      @@Premio_paso_salida
    end

    def propiedades
      @propiedades
    end

    def salvoconducto
      @salvoconducto
    end
    
    def puede_comprar
      @puede_comprar
    end

    def saldo
      @saldo
    end

    def hipotecar(ip)
      result=false
      if(@encarcelado)
        return result
      end
      if(existe_la_propiedad(ip))
        propiedad=@propiedades.at(ip)
        result=propiedad.hipotecar(self)
      end
      if(result)
        Diario.instance.ocurre_evento("EL jugador #{@nombre} hipoteca la propiedad #{ip}")
      end
      result
    end

    def is_encarcelado
      @encarcelado
    end

    def modificar_saldo(cantidad)
      @saldo+=cantidad
      evento="El salgo del jugador #{@nombre} ha sido modificado en #{cantidad}"
      Diario.instance.ocurre_evento(evento)
      true
    end

    def mover_a_casilla(num_casilla)
      resultado=false
      if(!@encarcelado && num_casilla>=0)
        @num_casilla_actual=num_casilla
        @puede_comprar=false
        resultado=true
        evento="El jugador #{@nombre} se ha movido a la casilla #{num_casilla}"
      end
      resultado
    end

    def obtener_salvoconducto(sorpresa)
      resultado=false
      if(!@encarcelado)
        @salvoconducto=sorpresa
        resultado=true
      end
      resultado
    end

    def paga(cantidad)
      modificar_saldo(cantidad*(-1))
    end

    def paga_alquiler(cantidad)
      if(@encarcelado)
        resultado=false
      else
        resultado=paga(cantidad)
      end
      resultado
    end

    def paga_impuesto(cantidad)
      resultado=false
      if(!@encarcelado)
        resultado=paga(cantidad)
      end
      resultado
    end

    def pasa_por_salida
      modificar_saldo(@@Paso_por_salida)
      evento="El jugador #{@nombre} ha pasado por la salida"
      Diario.instance.ocurre_evento(evento)
    end

    def perder_salvoconducto
      @salvoconducto.usada
      @salvoconducto=nil
    end

    def puede_comprar_casilla
      if(@encarcelado)
        @puede_comprar=false
      else
        @puede_comprar=true
      end
      @puede_comprar
    end

    def puede_salir_carcel_pagando
      @saldo>=@@Precio_libertad
    end

    def puedo_edificar_casa(propiedad)
      resultado=false
      precio=propiedad.precio_edificar
      if(puedo_gastar(precio) && propiedad.num_casas<=self.class.Casas_max)
        resultado=true
      end
      resultado
    end

    def puedo_edificar_hotel(propiedad)
      puedo_edificar_hotel=false
      precio=propiedad.precio_edificar
      if(puedo_gastar(precio))
        if(propiedad.num_hoteles<self.class.Hoteles_max && propiedad.num_casas>=self.class.Hoteles_max)
          puedo_edificar_hotel=true
        end
      end
      puedo_edificar_hotel
    end

    def puedo_gastar(precio)
      precio<=@saldo
    end

    def recibe(cantidad)
      @saldo+=cantidad
      true
    end

    def salir_carcel_pagando
      resultado=false
      if(@encarcelado && puede_salir_carcel_pagando)
        paga(@@Precio_libertad)
        @encarcelado=false
        evento="El jugador #{@nombre} sale de la carcel pagando"
        Diario.instance.ocurre_evento(evento)
        resultado=true
      end
      resultado
    end

    def salir_carcel_tirando
      resultado=false
      if(@encarcelado && puede_salir_carcel_pagando)
        paga(@@Precio_libertad)
        @encarcelado=false
        evento="El jugador #{@nombre} salde de la carcel pagando"
        Diario.instance.ocurre_evento(evento)
        resultado=true
      end
      resultado
    end

    def tiene_algo_que_gestionar
       @propiedades.length != 0
    end

    def tiene_salvoconducto
      @salvoconducto!=nil
    end

    def to_s
      cadena="Nombre #{@nombre}"
      cadena+="| Encarcelado: #{@encarcelado}"
      cadena+="| Especulador: #{is_especulador}"
      cadena+="| Casilla actual: #{@num_casilla_actual}"
      cadena+="| Saldo del jugador: #{@saldo}"
      cadena+="| Puede comprar: #{@puede_comprar}"
      cadena+="| Numero de propiedades: #{ @propiedades.length}"
      cadena
    end

    def vender(ip)
      res=false
      if(!@encarcelado && existe_la_propiedad(ip))
        res= @propiedades.at(ip).vender(self)
        if(res)
          evento="Se ha vendido la propiedad #{ @propiedades.at(ip).nombre} "
          evento+=" del jugador #{@nombre}"
          @propiedades.delete_at(ip)
          Diario.instance.ocurre_evento(evento)
        end
      end
      res
    end
    
      
    protected :debe_ser_encarcelado
      
    public  :is_encarcelado,  :<=>, :to_s
    
  end

end