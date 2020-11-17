# encoding:utf-8
require_relative 'casilla'

module Civitas
  class Tablero
    def initialize(ncc)
      if ncc>=1
        @num_casilla_carcel=ncc
      else
        @num_casilla_carcel=1
      end
      @casillas=Array.new
      @casillas.push(Casilla.new("Salida"))
      @por_salida=0
      @tiene_juez=false
    end
    
    #Metodos de instancia privados
    def correcto_p
      resultado=false
      if(@casillas.length > @num_casilla_carcel)
        resultado=true
      end
      resultado
    end
    
    def correcto(num_casilla)
      resultado=false
      if correcto_p && num_casilla<@casillas.length
        resultado=true
      end
      resultado
    end
    
    def por_salida
      resultado=@por_salida
      if(@por_salida>0)
        @por_salida-=1
      end
      resultado
    end
    
    def añade_casilla(c)
      if @casillas.size == @num_casilla_carcel
        @casillas.push(Casilla.new("Carcel"))
      end
      @casillas.push(c)
      if @casillas.size == @num_casilla_carcel
        @casillas.push(Casilla.new("Carcel"))
      end
    end
    
    def añade_juez
      if !@tieneJuez
        añade_casilla(Casilla_juez.new("Juez",@num_casilla_carcel))
      end
    end
    
    def casilla(numero)
      if(numero<@casillas.length && numero>=0)
        @casillas.at(numero)
      end
    end
    
    def nueva_posicion(actual,tirada)
      nuevaPos=-1
      if(correcto(actual))
        nuevaPos=(actual+tirada)%(@casillas.size-1)
        if(nuevaPos != (actual+tirada))
          @por_salida+=1
        end
      end
      nuevaPos
    end
    
    def calcular_tirada(origen,destino)
      tirada=destino-origen
      if tirada < 0
        tirada+=@casillas.size
      end
      tirada
    end
    
    def carcel
      @num_casilla_carcel
    end
  end
end
