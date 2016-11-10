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

  # Setters/Getters
  attr_reader :color
  attr_reader :letra
  attr_reader :nombre
  attr_reader :figura
  
  # Constructor
  def initialize(color)
  	@color = color
  	@letra = ""
  	@nombre = ""
  	@figura = ""
  end
end

class Torre < Pieza
  
  # Constructor
  def initialize(color)
  	super
  	@letra = "T"
  	@nombre = "Torre"
  	@figura = @color == Color::BLANCO ? "\u2656" : "\u265c"
  end

end

class Caballo < Pieza

  # Constructor
  def initialize(color)
  	super
  	@letra = "C"
  	@nombre = "Caballo"
  	@figura = @color == Color::BLANCO ? "\u2658" : "\u265e"
  end

end

class Alfil < Pieza

  # Constructor
  def initialize(color)
  	super
  	@letra = "A"
  	@nombre = "Alfil"
  	@figura = @color == Color::BLANCO ? "\u2657" : "\u265d"
  end

end

class Dama < Pieza

  # Constructor
  def initialize(color)
  	super
  	@letra = "D"
  	@nombre = "Dama"
  	@figura = @color == Color::BLANCO ? "\u2655" : "\u265b"
  end

end

class Rey < Pieza

  # Constructor
  def initialize(color)
  	super
  	@letra = "R"
  	@nombre = "Rey"
  	@figura = @color == Color::BLANCO ? "\u2654" : "\u265a"
  end

end

class Peon < Pieza

  # Constructor
  def initialize(color)
  	super
  	@letra = "P"
  	@nombre = "Peón"
  	@figura = @color == Color::BLANCO ? "\u2659" : "\u265f"
  end

end

class Escaque
  include Globales

  # Setters/Getters
  attr_reader :color
  attr_reader :identificacion
  attr_accessor :pieza

  # Variables de clase

  # Letras del abecedario, se utilizarán para asignar a cada escaque su identificación
  # según el sistema de notación algebraica que se utiliza en el ajedrez:
  #@@letras = ("a".."z").to_a


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
    #@identificacion = @@letras[columna - 1] + fila.to_s
    @identificacion = LETRAS[columna - 1] + fila.to_s


    # Se asigna el valor del atributo pieza, con una objeto de tipo Pieza, dependiendo del escaque en que se ubica,
    # para colocar las piezas en su posición inicial para iniciar una partida.
    @pieza = piezaInicio(fila, columna) 

  end

  # Métodos públicos de instancia

  # Métodos privados
  private

  def piezaInicio(fila, columna)
  	case 
  	  # En filas 2 y 7 se colocan los peones:	
      when (fila == 2 || fila == 7) then Peon.new(fila == 2 ? Color::BLANCO : Color::NEGRO)
      
      # En esquinas se colocan las torres:
      when (columna == 1 || columna == 8) && (fila == 1 || fila == 8) then Torre.new(fila == 1 ? Color::BLANCO : Color::NEGRO)
 
      # Junto a las torres se colocan los caballos:
      when (columna == 2 || columna == 7) && (fila == 1 || fila == 8) then Caballo.new(fila == 1 ? Color::BLANCO : Color::NEGRO)
      
      # Junto a los caballos se colocan los alfiles:
      when (columna == 3 || columna == 6) && (fila == 1 || fila == 8) then Alfil.new(fila == 1 ? Color::BLANCO : Color::NEGRO)

      # Damas se colocan en su color:
      # Dama blanca
      when (columna == 4 && fila == 1) then Dama.new(Color::BLANCO)
      # Dama negra
      when (columna == 5 && fila == 8) then Dama.new(Color::NEGRO)

      # Rey se coloca junto a la dama:
      # Rey blanco
      when (columna == 5 && fila == 1) then Rey.new(Color::BLANCO)
      # Rey negro
      when (columna == 4 && fila == 8) then Rey.new(Color::NEGRO)

      # para demás posiciones retorna nil
      else nil
    end
  end

end



class Tablero
  include Globales

  # Constantes
  Q_FILAS = 8
  Q_COLUMNAS = 8

  # Setters/Getters

  # escaques:  Arreglo bidimensional que contiene las casillas (escaques) que conforman el tablero, 
  #            y las piezas colocadas en su respectiva casilla para iniciar una partida de ajedrez
  attr_reader :escaques

  # jugada:  Número de la jugada, nos permite determinar cuál color juega, Impar = Juegan blancas, Par = Juegan negras
  #          También es útil para describir en notación algebraica la secuencia de movimientos de una partida
  attr_accessor :jugada

  # Constructor
  def initialize
  	@escaques = Array.new(Q_FILAS) { |indexy| Array.new(Q_COLUMNAS) { |indexx| Escaque.new(indexy + 1, indexx + 1) } }
  	@jugada = 1
  end

  # Métodos públicos de instancia
  def to_s
    # Se crea esta función para "pintar" el tablero en pantalla
    
    string_builder = StringIO.new

    # Números de filas
    for fila in 0..Q_FILAS
      string_builder.print (fila == 0 ? " ".center(3) : fila.to_s.center(3))
    end

    # Salto de línea
    string_builder.puts

    for columna in 1..Q_COLUMNAS

      # Letras de columnas
      string_builder.print LETRAS[columna - 1].center(3)

      # Piezas
      for fila in 1..Q_FILAS
      	if fila < 8 
 	      string_builder.print self.getEscaque(fila,columna).pieza.nil? ? " ".center(3) : self.getEscaque(fila,columna).pieza.figura.center(3)
        else
          string_builder.puts self.getEscaque(fila,columna).pieza.nil? ? " ".center(3) : self.getEscaque(fila,columna).pieza.figura.center(3)	
        end 
      end
    end 
    return string_builder.string
  end

  def getEscaque(fila, columna)
    # Se crea esta función para poder obtener un escaque por sus coordenadas (fila, columna),
    # ya que el Array de escaques es base 0.
    return @escaques[fila - 1] [columna - 1]
  end

end


##########################################
# Inicia la ejecución de nuestro programa:
##########################################

# Se instancia el tablero, iniciando una partida:
tablero = Tablero.new

salir = "N"
loop do
  print "Salir? (S/N) "
  salir = gets.chomp
  break if salir.upcase == "S"
  
  puts tablero.to_s
  puts "Jugada: " + tablero.jugada.to_s + ", Juegan: " + (tablero.jugada.odd? ? "Blancas" : "Negras")
  tablero.jugada += 1
  
end
