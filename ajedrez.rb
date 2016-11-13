# Ajedrez, v4.
# 13/11/2016

# Carolina Cordero

# Piezas implementadas con todos sus movimientos y comiendo:
# Peón
# Caballo
# Rey
# Torre

module Globales
  # Letras del abecedario, se utilizarán para asignar a cada escaque su identificación
  # según el sistema de notación algebraica que se utiliza en el ajedrez:
  LETRAS = ("a".."z").to_a
end

class Color
	BLANCO = "B"
 	NEGRO = "N"
end

class Pieza

  # Variables privadas de instancia
  # puede_mover:  true o false, indica si en la siguiente jugada la pieza se puede mover
  @puede_mover

  # Setters/Getters
  attr_reader :color
  attr_reader :letra
  attr_reader :nombre
  attr_reader :figura
  attr_reader :movimientos_posibles
  attr_accessor :fila
  attr_accessor :columna
  
  # Constructor
  def initialize(color, fila, columna)
  	@color = color
    @fila = fila
    @columna = columna
  end

  # Métodos públicos de instancia

  # Set y Get de variables privadas de instancia:
  def puede_mover=(valor) #writer
   @puede_mover = valor
  end

  # Comportamiento
  def puede_mover?
    return @puede_mover
  end
  
end

class Torre < Pieza
  
  # Constructor
  def initialize(color, fila, columna)
  	super
  	@letra = "T"
  	@nombre = "Torre"
  	@figura = @color == Color::BLANCO ? "\u2656" : "\u265c"
  end

  # Métodos públicos de instancia

  # Comportamiento
  def calcular_movimientos_posibles(tablero)
    movimientos_posibles = Array.new

    # Direcciones ortogonales, n casillas 

    # Los movimientos se harán en una sola dirección a la vez, para poder hacer un break cuando
    # se detecta que la pieza está siendo bloqueada y por lo tanto no puede avanzar más alla 
    # del escaque donde encuentra otra pieza:

    # Movimiento hacia la izquierda:
    (1..(@fila - 1)).each { |suma_fila| 
      fila_destino = @fila + -(suma_fila)
      # Si el movimiento es dentro de las dimensiones del tablero:
      if (fila_destino >= 1 && fila_destino <= tablero.Q_FILAS)
        # Si el escaque destino está vacío, o si la pieza que lo ocupa es del jugador contrario:
        pieza_en_destino= tablero.get_escaque(fila_destino, @columna).pieza
        if (pieza_en_destino.nil? || pieza_en_destino.color != tablero.color_que_juega)
          # Escaque destino se agrega a movimientos disponibles:
          # Se determina si con el movimiento la pieza come (se pregunta si el escaque destino está vacío):
          come = !(tablero.get_escaque(fila_destino, @columna).pieza.nil?)
          
          # Movimiento = en función del color de la pieza:
          movimiento = ""
          if fila_destino >= @fila
            if tablero.color_que_juega == Color::BLANCO
              movimiento = "avanza"
            else
              movimiento = "retrocede"
            end
          else
            if tablero.color_que_juega == Color::NEGRO
              movimiento = "avanza"
            else
              movimiento = "retrocede"
            end
          end
          movimientos_posibles.push([tablero.get_escaque(fila_destino, @columna), come, movimiento, fila_destino, @columna])
          @puede_mover = true
          if come == true
            break
          end
        elsif (!(pieza_en_destino.nil?) && pieza_en_destino.color == tablero.color_que_juega)
          break
        end
      else
        break
      end
    }

    # Movimiento hacia la derecha:
    (1..(tablero.Q_FILAS - @fila)).each { |suma_fila| 
      fila_destino = @fila + suma_fila
      # Si el movimiento es dentro de las dimensiones del tablero:
      if (fila_destino >= 1 && fila_destino <= tablero.Q_FILAS)
        # Si el escaque destino está vacío, o si la pieza que lo ocupa es del jugador contrario:
        pieza_en_destino= tablero.get_escaque(fila_destino, @columna).pieza
        if (pieza_en_destino.nil? || pieza_en_destino.color != tablero.color_que_juega)
          # Escaque destino se agrega a movimientos disponibles:
          # Se determina si con el movimiento la pieza come (se pregunta si el escaque destino está vacío):
          come = !(tablero.get_escaque(fila_destino, @columna).pieza.nil?)
          
          # Movimiento = en función del color de la pieza:
          movimiento = ""
          if fila_destino >= @fila
            if tablero.color_que_juega == Color::BLANCO
              movimiento = "avanza"
            else
              movimiento = "retrocede"
            end
          else
            if tablero.color_que_juega == Color::NEGRO
              movimiento = "avanza"
            else
              movimiento = "retrocede"
            end
          end
          movimientos_posibles.push([tablero.get_escaque(fila_destino, @columna), come, movimiento, fila_destino, @columna])
          @puede_mover = true
          if come == true
            break
          end
        elsif (!(pieza_en_destino.nil?) && pieza_en_destino.color == tablero.color_que_juega)
          break
        end
      else
        break
      end
    }

    # Movimiento hacia la arriba:
    (1..(@columna - 1)).each { |suma_columna| 
      columna_destino = @columna + -(suma_columna)
      # Si el movimiento es dentro de las dimensiones del tablero:
      if (columna_destino >= 1 && columna_destino <= tablero.Q_COLUMNAS)
        # Si el escaque destino está vacío, o si la pieza que lo ocupa es del jugador contrario:
        pieza_en_destino= tablero.get_escaque(@fila, columna_destino).pieza
        if (pieza_en_destino.nil? || pieza_en_destino.color != tablero.color_que_juega)
          # Escaque destino se agrega a movimientos disponibles:
          # Se determina si con el movimiento la pieza come (se pregunta si el escaque destino está vacío):
          come = !(tablero.get_escaque(@fila, columna_destino).pieza.nil?)
          
          movimiento = "avanza"
          
          movimientos_posibles.push([tablero.get_escaque(@fila, columna_destino), come, movimiento, @fila, columna_destino])
          @puede_mover = true
          if come == true
            break
          end
        elsif (!(pieza_en_destino.nil?) && pieza_en_destino.color == tablero.color_que_juega)
          break
        end
      else
        break
      end
    }

    # Movimiento hacia abajo:
    (1..(tablero.Q_COLUMNAS - @columna)).each { |suma_columna| 
      columna_destino = @columna + suma_columna
      # Si el movimiento es dentro de las dimensiones del tablero:
      if (columna_destino >= 1 && columna_destino <= tablero.Q_COLUMNAS)
        # Si el escaque destino está vacío, o si la pieza que lo ocupa es del jugador contrario:
        pieza_en_destino= tablero.get_escaque(@fila, columna_destino).pieza
        if (pieza_en_destino.nil? || pieza_en_destino.color != tablero.color_que_juega)
          # Escaque destino se agrega a movimientos disponibles:
          # Se determina si con el movimiento la pieza come (se pregunta si el escaque destino está vacío):
          come = !(tablero.get_escaque(@fila, columna_destino).pieza.nil?)
          
          movimiento = "avanza"
          
          movimientos_posibles.push([tablero.get_escaque(@fila, columna_destino), come, movimiento, @fila, columna_destino])
          @puede_mover = true
          if come == true
            break
          end
        elsif (!(pieza_en_destino.nil?) && pieza_en_destino.color == tablero.color_que_juega)
          break
        end
      else
        break
      end
    }


    @movimientos_posibles = movimientos_posibles
  end
end

class Caballo < Pieza

  # Constructor
  def initialize(color, fila, columna)
  	super
  	@letra = "C"
  	@nombre = "Caballo"
  	@figura = @color == Color::BLANCO ? "\u2658" : "\u265e"
  end

  # Métodos públicos de instancia
  def calcular_movimientos_posibles(tablero)
    movimientos_posibles = Array.new

    # Movimiento en forma de L:

    [-2, 2].each { |mueve_dos| 
      [-1, 1].each { |mueve_uno| 

        # Movimiento 1:  mueve dos filas y una columna
        fila_destino = @fila + mueve_dos
        # Si el movimiento es dentro de las dimensiones del tablero:
        if (fila_destino >= 1 && fila_destino <= tablero.Q_FILAS) 
          columna_destino = @columna + mueve_uno

          # Si el movimiento es dentro de las dimensiones del tablero:
          if (columna_destino >= 1 && columna_destino <= tablero.Q_COLUMNAS)

            # Si el escaque destino está vacío, o si la pieza que lo ocupa es del jugador contrario:
            pieza_en_destino= tablero.get_escaque(fila_destino, columna_destino).pieza
            if (pieza_en_destino.nil? || pieza_en_destino.color != tablero.color_que_juega)

              # Escaque destino se agrega a movimientos disponibles:

              # Se determina si con el movimiento la pieza come (se pregunta si el escaque destino está vacío):
              come = !(tablero.get_escaque(fila_destino, columna_destino).pieza.nil?)
              
              # Movimiento = en función del color de la pieza:
              movimiento = ""
              if fila_destino > @fila
                if tablero.color_que_juega == Color::BLANCO
                  movimiento = "avanza"
                else
                  movimiento = "retrocede"
                end
              else
                if tablero.color_que_juega == Color::NEGRO
                  movimiento = "avanza"
                else
                  movimiento = "retrocede"
                end
              end
              movimientos_posibles.push([tablero.get_escaque(fila_destino, columna_destino), come, movimiento, fila_destino, columna_destino])
              @puede_mover = true
            end
          end
        end


        # Movimiento 2:  mueve una fila y dos columnas
        fila_destino = @fila + mueve_uno
        # Si el movimiento es dentro de las dimensiones del tablero:
        if (fila_destino >= 1 && fila_destino <= tablero.Q_FILAS) 
          columna_destino = @columna + mueve_dos
          # Si el movimiento es dentro de las dimensiones del tablero:
          if (columna_destino >= 1 && columna_destino <= tablero.Q_COLUMNAS)

            # Si el escaque destino está vacío, o si la pieza que lo ocupa es del jugador contrario:
            pieza_en_destino= tablero.get_escaque(fila_destino, columna_destino).pieza
            if (pieza_en_destino.nil? || pieza_en_destino.color != tablero.color_que_juega)
              # Escaque destino se agrega a movimientos disponibles:
            
              # Se determina si con el movimiento la pieza come (se pregunta si el escaque destino está vacío):
              come = !(tablero.get_escaque(fila_destino, columna_destino).pieza.nil?)

              # Movimiento = en función del color de la pieza:
              movimiento = ""
              if fila_destino > @fila
                if tablero.color_que_juega == Color::BLANCO
                  movimiento = "avanza"
                else
                  movimiento = "retrocede"
                end
              else
                if tablero.color_que_juega == Color::NEGRO
                  movimiento = "avanza"
                else
                  movimiento = "retrocede"
                end
              end
              movimientos_posibles.push([tablero.get_escaque(fila_destino, columna_destino), come, movimiento, fila_destino, columna_destino])
              @puede_mover = true
              end
          end
        end

      } # .each mueve_uno
    } # .each mueve_dos

    @movimientos_posibles = movimientos_posibles

  end
end

class Alfil < Pieza

  # Constructor
  def initialize(color, fila, columna)
  	super
  	@letra = "A"
  	@nombre = "Alfil"
  	@figura = @color == Color::BLANCO ? "\u2657" : "\u265d"
  end

  # Métodos públicos de instancia
  def calcular_movimientos_posibles(tablero)
  end

end

class Dama < Pieza

  # Constructor
  def initialize(color, fila, columna)
  	super
  	@letra = "D"
  	@nombre = "Dama"
  	@figura = @color == Color::BLANCO ? "\u2655" : "\u265b"
  end

  # Métodos públicos de instancia

  # Comportamiento
  def calcular_movimientos_posibles(tablero)
    movimientos_posibles = Array.new
    
    # En todas las direcciones, n escaques a la vez, mientras no esté bloqueada:

    
    @movimientos_posibles = movimientos_posibles
  end

end

class Rey < Pieza

  # Constructor
  def initialize(color, fila, columna)
  	super
  	@letra = "R"
  	@nombre = "Rey"
  	@figura = @color == Color::BLANCO ? "\u2654" : "\u265a"
  end

  # Métodos públicos de instancia

  # Comportamiento
  def calcular_movimientos_posibles(tablero)
    movimientos_posibles = Array.new
    
    # En todas las direcciones, un sólo escaque a la vez:

    [-1, 0, 1].each { |suma_fila| 
      [-1, 0, 1].each { |suma_columna| 
        fila_destino = @fila + suma_fila
        columna_destino = @columna + suma_columna

        # Si el movimiento es dentro de las dimensiones del tablero:
        if (fila_destino >= 1 && fila_destino <= tablero.Q_FILAS) && (columna_destino >= 1 && columna_destino <= tablero.Q_COLUMNAS)
          # Si el escaque destino está vacío, o si la pieza que lo ocupa es del jugador contrario:
          pieza_en_destino= tablero.get_escaque(fila_destino, columna_destino).pieza
          if (pieza_en_destino.nil? || pieza_en_destino.color != tablero.color_que_juega)

            # Escaque destino se agrega a movimientos disponibles:

            # Se determina si con el movimiento la pieza come (se pregunta si el escaque destino está vacío):
            come = !(tablero.get_escaque(fila_destino, columna_destino).pieza.nil?)
            
            # Movimiento = en función del color de la pieza:
            movimiento = ""
            if fila_destino >= @fila
              if tablero.color_que_juega == Color::BLANCO
                movimiento = "avanza"
              else
                movimiento = "retrocede"
              end
            else
              if tablero.color_que_juega == Color::NEGRO
                movimiento = "avanza"
              else
                movimiento = "retrocede"
              end
            end
            movimientos_posibles.push([tablero.get_escaque(fila_destino, columna_destino), come, movimiento, fila_destino, columna_destino])
            @puede_mover = true
          end
        end
      }
    }
    @movimientos_posibles = movimientos_posibles
  end

end # class Rey

class Peon < Pieza

  # Variables privadas de instancia
  # es_primer_movimiento:  true o false, indica si el siguiente movimiento que hará el peón es su primer movimiento
  @es_primer_movimiento

  # Constructor
  def initialize(color, fila, columna)
  	super
    @es_primer_movimiento = true
  	@letra = "P"
  	@nombre = "Peón"
  	@figura = @color == Color::BLANCO ? "\u2659" : "\u265f"
  end

  # Métodos públicos de instancia
  
  # Set y Get de variables privadas de instancia:
  def fila=(valor) #writer
   @fila = valor
   @es_primer_movimiento = false
  end

  # Comportamiento
  def calcular_movimientos_posibles(tablero)
    movimientos_posibles = Array.new

    # Sólo hacia adelante una casilla:
    fila_destino = (tablero.color_que_juega == Color::BLANCO ? @fila + 1 : @fila - 1)
    # Si el movimiento es dentro de las dimensiones del tablero:
    if (fila_destino >= 1 && fila_destino <= tablero.Q_FILAS) 
      # Si escaque destino está vacío:
      if tablero.get_escaque(fila_destino, @columna).pieza.nil?
        # Escaque destino se agrega a movimientos disponibles:
        # Come = false
        # Movimiento = avanza
        movimientos_posibles.push([tablero.get_escaque(fila_destino, @columna), false, "avanza", fila_destino, @columna])
        @puede_mover = true
      end

      # Si puede comer con un movimiento diagonal una casilla hacia adelante:
      [-1, 1].each { |suma_columna| 

        columna_destino = @columna + suma_columna

        # Si el movimiento es dentro de las dimensiones del tablero:
        if (columna_destino >= 1 && columna_destino <= tablero.Q_COLUMNAS)
          # Si escaque destino está ocupado por una pieza del jugador contrario:
          pieza_en_destino= tablero.get_escaque(fila_destino, columna_destino).pieza
          if !(pieza_en_destino.nil?) 
            if pieza_en_destino.color != tablero.color_que_juega
              # Escaque destino se agrega a movimientos disponibles:
              # Come = true
              # Movimiento = avanza
              movimientos_posibles.push([tablero.get_escaque(fila_destino, columna_destino), true, "avanza", fila_destino, columna_destino])
              @puede_mover = true
            end
          end
        end
      }
    end

    # Si es el primer movimiento del peón, también puede moverse dos casillas hacia adelante,
    # siempre que ambas están vacías:
    if es_primer_movimiento?
      fila_destino = (tablero.color_que_juega == Color::BLANCO ? @fila + 2 : @fila - 2)
      # Si el movimiento es dentro de las dimensiones del tablero:
      if (fila_destino >= 1 && fila_destino <= tablero.Q_FILAS)
        # Si escaque destino está vacío:
        if tablero.get_escaque(fila_destino, @columna).pieza.nil?
          # Si escaque anterior al destino está vacío:
          if tablero.get_escaque((tablero.color_que_juega == Color::BLANCO ? fila_destino - 1 : fila_destino + 1), @columna).pieza.nil?
            # Escaque destino se agrega a movimientos disponibles:
            # Come = false
            # Movimiento = avanza
            movimientos_posibles.push([tablero.get_escaque(fila_destino, @columna), false, "avanza", fila_destino, @columna])
            @puede_mover = true
          end
        end
      end
    end

    @movimientos_posibles = movimientos_posibles
  end

  # Métodos privados
  private

  def es_primer_movimiento?
    return @es_primer_movimiento
  end
end

class Escaque
  include Globales

  # Setters/Getters
  attr_reader :color
  attr_reader :identificacion
  attr_accessor :pieza

  # Variables de clase

  # Constructor
  def initialize(fila, columna)

    # Se asigna el color al escaque:  si fila y columna son pares, o fila y columna son impares, el color es Negro.
    # Si la combinación es fila=par y columna=impar o viceversa, entonces el color es blanco
    @color = (fila.even? && columna.even?) || (fila.odd? && columna.odd?) ? Color::NEGRO : Color::BLANCO

    # Se asigna la identificación al escaque, conforme con la notación del ajedrez, que dice:
    # El primer caracter identifica la columna de la casilla, y se representa por una de las siguientes letras
    # minúsculas a, b, c, d, e, f, g y h, ordenadas desde la izquierda del jugador con las piezas blancas hasta 
    # su derecha.  El segundo caracter de una casilla identifica su línea (fila) y se representa por un número del 1 al 8, 
    # en orden ascendente, desde el lado del jugador de piezas blancas hasta el lado del jugador de piezas negras.
    @identificacion = LETRAS[columna - 1] + fila.to_s


    # Se asigna el valor del atributo pieza, con una objeto de tipo Pieza, dependiendo del escaque en que se ubica,
    # para colocar las piezas en su posición inicial para iniciar una partida.
    @pieza = pieza_inicio(fila, columna) 

  end

  # Métodos públicos de instancia

  # Métodos privados
  private

  def pieza_inicio(fila, columna)
  	case 
  	  # En filas 2 y 7 se colocan los peones:	
      when (fila == 2 || fila == 7) then Peon.new((fila == 2 ? Color::BLANCO : Color::NEGRO), fila, columna)
      
      # En esquinas se colocan las torres:
      when (columna == 1 || columna == 8) && (fila == 1 || fila == 8) then Torre.new((fila == 1 ? Color::BLANCO : Color::NEGRO), fila, columna)
 
      # Junto a las torres se colocan los caballos:
      when (columna == 2 || columna == 7) && (fila == 1 || fila == 8) then Caballo.new((fila == 1 ? Color::BLANCO : Color::NEGRO), fila, columna)
      
      # Junto a los caballos se colocan los alfiles:
      when (columna == 3 || columna == 6) && (fila == 1 || fila == 8) then Alfil.new((fila == 1 ? Color::BLANCO : Color::NEGRO), fila, columna)

      # Damas se colocan en su color:
      # Dama blanca
      when (columna == 4 && fila == 1) then Dama.new(Color::BLANCO, fila, columna)
      # Dama negra
      when (columna == 5 && fila == 8) then Dama.new(Color::NEGRO, fila, columna)

      # Rey se coloca junto a la dama:
      # Rey blanco
      when (columna == 5 && fila == 1) then Rey.new(Color::BLANCO, fila, columna)
      # Rey negro
      when (columna == 4 && fila == 8) then Rey.new(Color::NEGRO, fila, columna)

      # para demás posiciones retorna nil
      else nil
    end
  end

end



class Tablero
  include Globales

  # Variables privadas de instancia

  # jugada:  Número de la jugada, nos permite determinar cuál color juega, Impar = Juegan blancas, Par = Juegan negras
  #          También es útil para describir en notación algebraica la secuencia de movimientos de una partida
  @jugada

  # color_que_juega:  indica el color al que le toca jugar, con base en el número de jugada
  @color_que_juega

  # Constantes
  Q_FILAS = 8
  Q_COLUMNAS = 8

  # Setters/Getters

  # escaques:  Arreglo bidimensional que contiene las casillas (escaques) que conforman el tablero, 
  #            y las piezas colocadas en su respectiva casilla para iniciar una partida de ajedrez
  attr_reader :escaques

  # Constructor
  def initialize
  	@escaques = Array.new(Q_FILAS) { |index_y| Array.new(Q_COLUMNAS) { |index_x| Escaque.new(index_y + 1, index_x + 1) } }
  	self.jugada = 1
    self.calcular_movimientos_posibles
  end

  # Métodos públicos de instancia
  
  # Set y Get de variables privadas de instancia:
  def jugada #reader
   @jugada
  end

  def jugada=(valor) #writer
   @jugada = valor
   @color_que_juega = (@jugada.odd? ? Color::BLANCO : Color::NEGRO)
  end

  def color_que_juega #reader
   @color_que_juega
  end

  # Get de constantes:
  def Q_FILAS
    Q_FILAS
  end
  def Q_COLUMNAS
    Q_COLUMNAS
  end

  # Comportamiento:
  def to_s
    # Se crea esta función para "pintar" el tablero en pantalla
    
    string_builder = StringIO.new

    # Salto de línea
    string_builder.puts

    # Números de filas
    (0..Q_FILAS).each { |fila| string_builder.print (fila == 0 ? " ".center(3) : fila.to_s.center(3))}

    # Salto de línea
    string_builder.puts

    for columna in 1..Q_COLUMNAS

      # Letras de columnas
      string_builder.print LETRAS[columna - 1].center(3)

      # Piezas
      for fila in 1..Q_FILAS
      	if fila < 8 
 	      string_builder.print self.get_escaque(fila, columna).pieza.nil? ? " ".center(3) : self.get_escaque(fila, columna).pieza.figura.center(3)
        else
          string_builder.puts self.get_escaque(fila, columna).pieza.nil? ? " ".center(3) : self.get_escaque(fila, columna).pieza.figura.center(3)	
        end 
      end
    end 

    # Salto de línea
    string_builder.puts

    return string_builder.string
  end

  def get_escaque(fila, columna)
    # Se crea esta función para poder obtener un escaque por sus coordenadas (fila, columna),
    # ya que el Array de escaques es base 0.
    return @escaques[fila - 1] [columna - 1]
  end

  def get_escaques_a_mover
    # Se crea esta función para obtener la lista de los escaques que contienen las piezas que el jugador puede mover.
    # El jugador (Blancas o Negras) se determina a partir del número de jugada

    arreglo_escaques = Array.new

    @escaques.each { |fila_array| 
      fila_array.each { |escaque| 
        if !(escaque.pieza.nil?)
          if escaque.pieza.color == @color_que_juega && escaque.pieza.puede_mover?
            arreglo_escaques.push(escaque)
          end
        end
      }
    }
    
    return arreglo_escaques
  end

  def calcular_movimientos_posibles
    # Recorre todas las piezas del color que tiene el turno, y
    # solicita a cada pieza recalcular las jugadas posibles con base en su tipo y
    # en la disposición actual de las piezas en el tablero
    @escaques.each { |fila_array| 
      fila_array.each { |escaque| 
        if !(escaque.pieza.nil?)
          if escaque.pieza.color == @color_que_juega
            escaque.pieza.calcular_movimientos_posibles(self)
          end
        end
      }
    }
  end

  def mover_pieza(escaque_origen, escaque_destino)
    # Puede optimizarse llamando a un método de la pieza:
    escaque_destino[0].pieza = nil
    escaque_destino[0].pieza = escaque_origen.pieza
    escaque_destino[0].pieza.fila = escaque_destino[3]
    escaque_destino[0].pieza.columna = escaque_destino[4]
    escaque_destino[0].pieza.puede_mover = false

    escaque_origen.pieza = nil

    self.jugada  += 1
    self.calcular_movimientos_posibles
  end

end


##########################################
# Inicia la ejecución de nuestro programa:
##########################################

# Se instancia el tablero, iniciando una partida:
tablero = Tablero.new

salir = "N"
pieza_a_mover = ""
piezas_a_mover = nil

loop do
  print "Salir? (S/N) "
  salir = gets.chomp
  break if salir.upcase == "S"
  
  puts tablero.to_s
  puts "Jugada: " + tablero.jugada.to_s + ", Juegan: " + (tablero.color_que_juega == Color::BLANCO ? "Blancas" : "Negras")
  puts
  puts "Indique el número de la pieza que desea mover:"
  escaques_a_mover = tablero.get_escaques_a_mover()
  escaques_a_mover.each_with_index do |escaque, index| 
    puts "#{index} = #{escaque.pieza.nombre} en #{escaque.identificacion}" 
  end
  puts
  print "Pieza a mover? "
  index_escaque_a_mover = gets.chomp
  
  # Validar caracteres digitados

  puts
  puts "Indique el número de la jugada que desea realizar:"
  pieza_a_mover = "#{escaques_a_mover[index_escaque_a_mover.to_i].pieza.nombre} en #{escaques_a_mover[index_escaque_a_mover.to_i].identificacion}"
  escaques_a_mover[index_escaque_a_mover.to_i].pieza.movimientos_posibles.each_with_index do |(escaque, come, movimiento), index|
    puts "#{index} = #{pieza_a_mover} #{movimiento} a #{escaque.identificacion} #{come == true ? "(Con este movimiento come)" : ""}"
  end
  
  puts
  print "Jugada a realizar? "
  index_movimiento_a_realizar = gets.chomp

  # Validar caracteres digitados

  # Mover la pieza
  tablero.mover_pieza(escaques_a_mover[index_escaque_a_mover.to_i], escaques_a_mover[index_escaque_a_mover.to_i].pieza.movimientos_posibles[index_movimiento_a_realizar.to_i])

end
