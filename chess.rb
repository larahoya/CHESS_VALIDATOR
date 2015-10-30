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

	attr_reader :grid

	def initialize(grid)
		@grid = grid
	end

	def move_checking(initial, final)
		@grid[initial[0]][initial[1]].check_move(final)
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


pawn1 = Pawn.new(:wP, [1,7], "black")
rook1 = Rook.new(:wR, [0,0], "white")
queen1 = Queen.new(:wQ, [2,3], "white")
bishop1 = Bishop.new(:wB, [1,1], "white")
king1 = King.new(:wK, [6,4], "white")
knight1 = Knight.new(:wN, [5,2], "white")


grid1 = [[rook1,nil,nil,nil,nil,nil,nil,nil],
		[nil,bishop1,nil,nil,nil,nil,nil,pawn1],
		[nil,nil,nil,queen1,nil,nil,nil,nil],
		[nil,nil,nil,nil,nil,nil,nil,nil],
		[nil,nil,nil,nil,nil,nil,nil,nil],
		[nil,nil,knight1,nil,nil,nil,nil,nil],
		[nil,nil,nil,nil,nil,nil,nil,nil],
		[nil,nil,nil,nil,nil,nil,nil,nil]]

my_board = Board.new(grid1)

puts my_board.move_checking([0,0],[6,0])
puts my_board.move_checking([1,7],[3,7])
puts my_board.move_checking([2,3],[7,3])
puts my_board.move_checking([1,1],[2,0])
puts my_board.move_checking([5,2],[6,4])






