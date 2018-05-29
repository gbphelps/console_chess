class Piece

  attr_accessor :position, :moved
  attr_reader :color, :board

  def initialize(color, position, board)
    @color = color
    @position = position
    @board = board
    @moved = false
  end

  def color_symbol
    symbol.colorize(color)
  end

  def valid_moves
    moves.reject do |end_pos|
      test_board = board.dup
      test_board.move_piece!(position, end_pos)
      test_board.in_check?(color)
    end
  end
end
