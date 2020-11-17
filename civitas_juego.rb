# encoding:utf-8
require_relative 'dado'
require_relative 'mazo_sorpresas'
require_relative 'tablero'
require_relative 'operaciones_juego'
require_relative 'jugador'
require_relative 'casilla_calle'
require_relative 'casilla_sorpresa'
require_relative 'casilla_juez'
require_relative 'casilla_impuesto'
require_relative 'sorpresa_pagar_cobrar'
require_relative 'sorpresa_por_casa_hotel'
require_relative 'sorpresa_por_jugador'
require_relative 'sorpresa_salir_carcel'
require_relative 'sorpresa_ir_carcel'
require_relative 'sorpresa_ir_casilla'
require_relative 'sorpresa_jugador_especulador'
require_relative 'estados_juego'
require_relative 'gestor_estados'


module Civitas
  class Civitas_juego
    def initialize(nombres)
      @jugadores=Array.new()
      for nombre in nombres do
        #Creamos jugador
        jugador=Jugador.new(nombre)
        @jugadores.push(jugador)
      end
      @gestor_estados=Gestor_estados.new
      @estado=@gestor_estados.estado_inicial
      @indice_jugador_actual=Dado.instance.quien_empieza(nombres.length)
      @mazo=Mazo_sorpresas.new
      inicializar_tablero(@mazo)
      inicializar_mazo_sorpresas(@tablero)
    end
    
    def avanza_jugador
      jugador_actual=@jugadores.at(@indice_jugador_actual)
      posicion_actual=jugador_actual.num_casilla_actual
      tirada=Dado.instance.tirar
      nueva_pos=@tablero.nueva_posicion(posicion_actual, tirada)
      casilla=@tablero.casilla(nueva_pos)
      contabilizar_pasos_por_salida(jugador_actual)
      jugador_actual.mover_a_casilla(nueva_pos)
      casilla.recibe_jugador(@indice_jugador_actual,@jugadores)
      contabilizar_pasos_por_salida(jugador_actual)
    end
    
    def cancelar_hipoteca(ip)
      @jugadores.at(@indice_jugador_actual).cancelar_hipoteca(ip)
    end
   
    def comprar
      res=false
      titulo=casilla_actual.titulo_propiedad
      res=jugador_actual.comprar(titulo)
      res
    end
    
    def construir_casa(ip)
      @jugadores.at(@indice_jugador_actual).construir_casa(ip)
    end
    
    def construir_hotel(ip)
      @jugadores.at(@indice_jugador_actual).construir_hotel(ip)
    end
    
    def contabilizar_pasos_por_salida(jugador)
      while @tablero.por_salida > 0
        res=jugador.pasa_por_salida
      end
    end
    
    def final_del_juego
      fin=false
      for jugador in @jugadores
        if(jugador.en_bancarrota)
          fin=true
        end
      end
      fin
    end
    
    def casilla_actual
      c=jugador_actual.num_casilla_actual
      @tablero.casilla(c)
    end
    
    def jugador_actual
      @jugadores.at(@indice_jugador_actual)
    end
    
    def hipotecar(ip)
      @jugadores.at(@indice_jugador_actual).hipotecar(ip)
    end
    
    def info_jugador_texto
      jugador_actual.to_s
    end
    
    def inicializar_mazo_sorpresas(tablero)
      #Sorpresa 1 PAGARCOBRAR
      s1=Sorpresa_pagar_cobrar.new("Cobras 1000",1000)
      @mazo.al_mazo(s1);
      
      #Sorpresa 2 PAGARCOBRAR
      s2=Sorpresa_pagar_cobrar.new("Pagas 1000",-1000)
      @mazo.al_mazo(s2);
      
      #Sorpresa 3 IRCASILLA
      s3=Sorpresa_ir_casilla.new("Te mueves a la casilla 7",7,tablero)
      @mazo.al_mazo(s3);
      
      #Sorpresa 4 IRCASILLA
      s4=Sorpresa_ir_casilla.new("Te vas a la casilla 0",0,tablero)
      @mazo.al_mazo(s4);
      
      #Sorpresa 5 IRCARCEL
      s5=Sorpresa_ir_carcel.new("Vas a la carcel",tablero)
      @mazo.al_mazo(s5);
      
      #Sorpresa 6 PORCASAHOTEL
      s6=Sorpresa_por_casa_hotel.new("Pierdes 50 por cada casa/hotel",-50)
      @mazo.al_mazo(s6);
      
      #Sorpresa 7 PORCASAHOTEL
      s7=Sorpresa_por_casa_hotel.new("Ganas 50 por cada casa/hotel",50)
      @mazo.al_mazo(s7);
      
      #Sorpresa 8 PORJUGADOR
      s8=Sorpresa_por_jugador.new("Recibes 250 de cada compañero",250)
      @mazo.al_mazo(s8);
      
      #Sorpresa 9 PORJUGADOR
      s9=Sorpresa_por_jugador.new("Pagas 150 a cada compañero",-150)
      @mazo.al_mazo(s9);
      
      #Sorpresa 10 SALIRCARCEL
      s10=Sorpresa_salir_carcel.new("Sales de la carcel",@mazo)
      @mazo.al_mazo(s10);
      
      #Sorpresa 11 JUGADORESPECULADOR
      s11=Sorpresa_jugador_especulador.new("Te conviertes en especulador",1000)
      @mazo.al_mazo(s11)
    end
    
    def inicializar_tablero(mazo)
      #El tablero tiene en total 20 casillas
        #1 Salida  
        #12 Casillas de Tipo Calle
        #3 Casillas de Tipo Sorpresa
        #1 Casilla de juez
        #1 Casilla de Carcel
        #1 Casilla de impuesto
        #1 Casilla de parking

        casilla_carcel=10
        
        #Casilla 0 SALIDA Y TABLERO
        @tablero=Tablero.new(casilla_carcel)
        
        #Casilla 1 Calle 0
        t0=Titulo_propiedad.new("Calle Gibraltar",55,4,400,400,550)
        calle0=Casilla_calle.new(t0)
        @tablero.añade_casilla(calle0)
        
        #Casilla 2 Calle 1
        t1=Titulo_propiedad.new("Calle Canarias",75,5,500,500,675)
        calle1=Casilla_calle.new(t1)
        @tablero.añade_casilla(calle1)
        
        #Casilla 3 Calle 2
        t2=Titulo_propiedad.new("La Atunara",95,6,520,520,750)
        calle2=Casilla_calle.new(t2)
        @tablero.añade_casilla(calle2)
        
        #Casilla 4 Sorpresa 0
        s0=Casilla_sorpresa.new("Sorpresa 0",mazo)
        @tablero.añade_casilla(s0)
          
        #Casilla 5 Calle 3
        t3=Titulo_propiedad.new("Avenida María Guerrero",100,7,575,575,900)
        calle3=Casilla_calle.new(t3)
        @tablero.añade_casilla(calle3)
        
        #Casilla 6 Calle 4
        t4=Titulo_propiedad.new("El Palenque",120,8,600,600,1000)
        calle4=Casilla_calle.new(t4)
        @tablero.añade_casilla(calle4)
        
        #Casilla 7 Impuesto
        impuesto=Casilla_impuesto.new(1000,"Peaje")
        @tablero.añade_casilla(impuesto)
         
        #Casilla 8 Calle 5
        t5=Titulo_propiedad.new("El Zabal",155,9,650,650,1200)
        calle5=Casilla_calle.new(t5)
        @tablero.añade_casilla(calle5)
        
        #Casilla 9 Calle 6
        t6=Titulo_propiedad.new("Calle Tabarca",200,10,680,680,1300)
        calle6=Casilla_calle.new(t6)
        @tablero.añade_casilla(calle6)
        
        #Casilla 10 Carcel
        #Ya esta añadida
        
        #Casilla 11 Calle 7
        t7=Titulo_propiedad.new("Avenida del Ejercito",225,11,725,725,1450)
        calle7=Casilla_calle.new(t7)
        @tablero.añade_casilla(calle7)
        
        #Casilla 12 Juez
        juez=Casilla_juez.new("Juez",casilla_carcel)
        @tablero.añade_casilla(juez)
        
        #Casilla 13 Parking(Descanso)
        descanso=Casilla.new("Parking")
        @tablero.añade_casilla(descanso);
        
        
        #Casilla 14 Calle 8
        t8=Titulo_propiedad.new("Cruz Herrera",260,11,850,850,1900)
        calle8=Casilla_calle.new(t8)
        @tablero.añade_casilla(calle8)
        
        #Casilla 15 Sorpresa 1
        s1=Casilla_sorpresa.new("Sorpresa 1",mazo)
        @tablero.añade_casilla(s1)
        
        #Casilla 16 Calle 9
        t9=Titulo_propiedad.new("Venta Melchor",450,14,1000,1000,2200)
        calle9=Casilla_calle.new(t9)
        @tablero.añade_casilla(calle9)
        
        #Casilla 17 Calle 10
        t10=Titulo_propiedad.new("Santa Margarita",750,20,1500,1500,2800)
        calle10=Casilla_calle.new(t10)
        @tablero.añade_casilla(calle10)
        
        #Casilla 18 Calle 11
        t11=Titulo_propiedad.new("La Alcaidesa",1000,25,2200,2200,4000)
        calle11=Casilla_calle.new(t11)
        @tablero.añade_casilla(calle11)
        
        #Casilla 19 Sorpresa 2
        s2=Casilla_sorpresa.new("Sorpresa 2",mazo)
        @tablero.añade_casilla(s2)
    end
    
    def pasar_turno
      @indice_jugador_actual=(@indice_jugador_actual+1)%@jugadores.length
    end

    def ranking
      ranking=Array.new
      ranking=@jugadores
      ranking.sort
      ranking.reverse
    end
    
    def salir_carcel_pagando
      jugador_actual.salir_carcel_pagando
    end
    
    def salir_carcel_tirando
      jugador_actual.salir_carcel_tirando
    end
    
    def siguiente_paso
      
      operacion=@gestor_estados.operaciones_permitidas(jugador_actual,@estado)
      if(operacion==Operaciones_juego::PASAR_TURNO)
        pasar_turno
        siguiente_paso_completado(operacion)
      elsif(operacion==Operaciones_juego::AVANZAR)
        avanza_jugador
        siguiente_paso_completado(operacion)
      end
      operacion
    end
    
    def siguiente_paso_completado(operacion)
      actual=jugador_actual
      @estado=@gestor_estados.siguiente_estado(actual,@estado,operacion)
    end
    
    def vender(ip)
      jugador_actual.vender(ip)
    end
    
    private :avanza_jugador,  :contabilizar_pasos_por_salida,
      :inicializar_mazo_sorpresas,  :inicializar_tablero,
      :pasar_turno
  end
  
  
end
