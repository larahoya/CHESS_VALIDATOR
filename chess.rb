module Movements

  def horizontal_vertical_move?(initial, final)
    final[0] == initial[0] || final[1] == initial[1]
  end

  def one_square_vertical_move?(initial, final)
    (final[0] == (initial[0] + 1) || final[0] == (initial[0] - 1)) &&  final[1] == initial[1]
  end

  def one_square_horizontal_move?(initial, final)
    final[0] == initial[0] &&  (final[1] == initial[1] + 1 || final[1] == initial[1] - 1)
  end

  def two_square_vertical_move?(initial, final)
    (final[0] == (initial[0] + 2) || final[0] == (initial[0] - 2)) &&  final[1] == initial[1]
  end

  def diagonal_move?(initial, final)
    (initial[0] - final[0]).abs == (initial[1] - final[1]).abs
  end

  def one_square_diagonal_move?(initial, final)
    (initial[0] - final[0]).abs == 1 && (initial[1] - final[1]).abs == 1
  end

  def knight_move?(initial, final)
    ((initial[0]-final[0]).abs == 2 && (initial[1]-final[1]).abs == 1) || ((initial[0]-final[0]).abs == 1 && (initial[1]-final[1]).abs == 2)
  end

end


class Board

  attr_reader :grid, :piece, :piece

  def initialize
    @grid = []
    @types_of_objects = {P: Pawn, R: Rook, N: Knight, B: Bishop, Q: Queen, K: King}
  end

  def read_grid_from_file(file)
    @grid = IO.read(file).split("\n").map do |line|
      line.split(' ').map do |element|
        if element == '--'
          element = nil
        else
          element.to_sym
        end
      end
    end
  end

  def read_movements_from_file(file)
    letters = {"a"=>0, "b"=>1, "c"=>2, "d"=>3, "e"=>4, "f"=>5, "g"=>6, "h"=>7, 
    "1"=>7, "2"=>6, "3"=>5, "4"=>4, "5"=>3, "6"=>2, "7"=>1, "8"=>0}
    moves = IO.read(file).split("\n").map do |line|
      line.split(' ').map do |element|
        element.reverse.split('').map do |c|
          c = letters[c]
        end
      end
    end
    return moves
  end

  def check_object(position)
    element = @grid[position[0]][position[1]]
    if element == nil
      return nil
    elsif element.to_s[0] == "b"
      color = "black"
      object_type = @types_of_objects[element[1].to_sym]
      object_type.new(element, position, color)
    else
      color = "white"
      object_type = @types_of_objects[element[1].to_sym]
      object_type.new(element, position, color)
    end
  end

  def is_empty?(destiny_position)
    @grid[destiny_position[0]][destiny_position[1]] == nil
  end

  def move_checking(move)
    piece = check_object(move[0])
    if piece != nil && is_empty?(move[1])
      piece.check_move(move[1])
    else
      return "ILLEGAL"
    end
  end

  def check_array_of_moves(file)
    results = read_movements_from_file(file).map do |move|
      move_checking(move)
    end
  end

  def write_file(initial_file, result_file)
    text = check_array_of_moves(initial_file). join("\n")
    IO.write(result_file, text)
  end 

end

class Piece

  attr_reader :piece, :position, :color
  include Movements

  def initialize(piece, position, color)
    @piece = piece
    @position = position
    @color = color
  end

end

class Rook < Piece

  def check_move(final_position)
    if horizontal_vertical_move?(@position, final_position)
      return "LEGAL"
    else
      return "ILLEGAL"
    end
  end

end

class Pawn < Piece

  def check_move(final_position)
    case @color
    when "white"
      if @position[0] > final_position[0] && (one_square_vertical_move?(@position, final_position) || two_square_vertical_move?(@position, final_position))
        return "LEGAL"
      else
        return "ILLEGAL"
      end
    when "black"
      if @position[0] < final_position[0] && (one_square_vertical_move?(@position, final_position) || two_square_vertical_move?(@position, final_position))
        return "LEGAL"
      else
        return "ILLEGAL"
      end
    end
  end

end

class Queen < Piece

  def check_move(final_position)
    if diagonal_move?(@position, final_position) || horizontal_vertical_move?(@position, final_position)
      return "LEGAL"
    else
      return "ILLEGAL"
    end
  end

end

class King < Piece

  def check_move(final_position)
    if one_square_diagonal_move?(@position, final_position) || one_square_horizontal_move?(@position, final_position) || one_square_vertical_move?(@position, final_position)
      return "LEGAL"
    else
      return "ILLEGAL"
    end
  end

end

class Bishop < Piece

  def check_move(final_position)
    if diagonal_move?(@position, final_position)
      return "LEGAL"
    else
      return "ILLEGAL"
    end
  end

end

class Knight < Piece

  def check_move(final_position)
    if knight_move?(@position, final_position)
      return "LEGAL"
    else
      return "ILLEGAL"
    end
  end

end


my_board = Board.new

my_board.read_grid_from_file('complex_board.txt')
my_board.write_file('complex_moves.txt','complex_result.txt')






