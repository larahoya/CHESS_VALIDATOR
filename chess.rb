require 'pry'

module Movements

	def horizontal_vertical_move?(initial, final)
		final[0] == initial[0] || final[1] == initial[1]
	end

	def one_square_vertical_move?(initial, final)
		final[0] == initial[0] + 1 &&  final[1] == initial[1]
	end

	def one_square_horizontal_move?(initial, final)
		final[0] == initial[0] &&  final[1] == initial[1] + 1
	end

	def two_square_vertical_move?(initial, final)
		final[0] == initial[0] + 2 ||  final[1] == initial[1]
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

	def check_object(position)
		element = @grid[position[0]][position[1]]
		if element[0]=='b'
			color = "black"
		else
			color = "white"
		end
		object_type = @types_of_objects[element[1].to_sym]
		object_type.new(element, position, color)
	end

	def move_checking(initial, final)
		piece = check_object(initial)
		piece.check_move(final)
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

	def empty_square?(board, square)
		board.grid[square[0]][square[1]] == nil
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

my_board.read_grid_from_file('board.txt')
puts my_board.move_checking([0,0],[5,0])







