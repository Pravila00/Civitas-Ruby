# encoding:utf-8
require_relative 'jugador'


module Civitas
  class Titulo_propiedad    
    @@factor_intereses_hipoteca=1.1
    
    def initialize(nom,ab,fr,hb,pc,pe)
      @alquiler_base=ab
      @factor_revalorizacion=fr
      @hipoteca_base=hb
      @hipotecado=false
      @nombre=nom
      @num_casas=0
      @num_hoteles=0
      @precio_compra=pc
      @precio_edificar=pe
      @propietario=nil
    end
    
    def actualiza_propietario_por_conversion(jugador)
      @propietario=jugador
    end
    
    
    def cancelar_hipoteca(jugador)
      result=false
      if(@hipotecado && es_este_el_propietario(jugador))
        @propietario.paga(importe_cancelar_hipoteca)
        @hipotecado=false
        result=true
      end
      result
    end
    
    def cantidad_casas_hoteles
      @num_casas+@num_hoteles
    end
    
    def comprar(jugador)
      result=false
      if(!tiene_propietario)
        @propietario=jugador
        result=true
        @propietario.paga(@precio_compra)
      end
      result
    end
    
    def construir_casa(jugador)
      result=false
      if(es_este_el_propietario(jugador))
        @propietario.paga(@precio_edificar)
        @num_casas+=1
        result=true
      end
    end
    
    def construir_hotel(jugador)
      result=false
      if(es_este_el_propietario(jugador))
        @propietario.paga(@precio_edificar)
        @num_hoteles+=1
        result=true
      end
      result
    end
    
    def derruir_casas(n,jugador)
      derruido=false
      if(es_este_el_propietario(jugador) && @num_casas >=n)
        @num_casas-=n
        derruido=true
      end
      derruido
    end
    
    def es_este_el_propietario(jugador)
      es_propietario=false
      res=@propietario<=>jugador
      if(res==0)
        es_propietario=true
      end
      es_propietario
    end
    
    def hipotecado
      @hipotecado
    end
    
    def importe_cancelar_hipoteca
      importe_hipoteca*@@factor_intereses_hipoteca
    end
    
    def importe_hipoteca
      @hipoteca_base*(1+(@num_casas*0.5)+(@num_hoteles*2.5))
    end
    
    def nombre
      @nombre
    end
    
    def num_casas
      @num_casas
    end
    
    def num_hoteles
      @num_hoteles
    end
    
    def precio_alquiler
      if(@hipotecado || propietario_encarcelado)
        alquiler=0
      else
        alquiler=@alquiler_base*(1+(@num_casas*0.5)+(@num_hoteles*2.5))
      end
      alquiler
    end
    
    def precio_compra
      @precio_compra
    end
    
    def precio_edificar
      @precio_edificar
    end
    
    def precio_venta
      @precio_compra+@precio_edificar*(@num_casas+5*@num_hoteles)*@factor_revalorizacion
    end
    
    def propietario
      @propietario
    end
    
    def hipotecar(jugador)
      salida=false
      if(!@hipotecado && es_este_el_propietario(jugador))
        @propietario.recibe(importe_hipoteca)
        @hipotecado=true
        salida=true
      end
      salida
    end
    
    def propietario_encarcelado
      encarcelado=false
      if(tiene_propietario && @propietario.is_encarcelado)
        encarcelado=true
      end
      encarcelado
    end
    
    def tiene_propietario
      @propietario!=nil
    end
    
    def to_s
      cadena=""
      cadena+="Nombre: #{@nombre}|"
      if(tiene_propietario)
        cadena+="Propietario #{@propietario.nombre} | "
      else
        cadena+="Sin propietario| "
      end
      
      if(@hipotecado)
        cadena+="Hipotecado| "
      else
        cadena+="No hipotecado| "
      end
      cadena+="Precio Compra: #{@precio_compra}| "
      cadena+="Precio Edificar: #{@precio_edificar}| "
      cadena+="Casas: #{@num_casas}| "
      cadena+="Hoteles: #{@num_hoteles}| "
    end
    
    def tramitar_alquiler(jugador)
      if(tiene_propietario && !es_este_el_propietario(jugador))
        jugador.paga_alquiler(precio_alquiler)
        @propietario.recibe(precio_alquiler)
      end
    end
    
    def vender(jugador)
      vendido=false
      if(es_este_el_propietario(jugador) && !@hipotecado)
        @propietario.recibe(precio_venta)
        @num_casas=0
        @num_hoteles=0
        @propietario=nil
        vendido=true
      end
      vendido
    end
    
        private :es_este_el_propietario,  :importe_hipoteca,  :precio_venta,
        :precio_alquiler, :propietario_encarcelado
  end
end
