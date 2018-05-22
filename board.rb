require 'byebug'
require 'colorize'
# require_relative 'pieces'

class StartPosError < ArgumentError; end
class EndPosError < ArgumentError; end

class Board
  ALL_POSITIONS = []
  8.times { |row| 8.times { |col| ALL_POSITIONS << [row, col] } }

  attr_reader :grid, :history
  attr_accessor :players

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    @history = [[nil, [0,4]]]
    # setup
  end

  def []=(pos,piece)
    row, col = pos
    self.grid[row][col] = piece
  end

  def [](pos)
    row, col = pos
    self.grid[row][col]
  end


  def move_piece(start_pos, end_pos)
    validate!(start_pos, end_pos)
    return nil unless self[start_pos].valid_moves.include?(end_pos)
    moving_piece = self[start_pos]

    #castling logic
    if moving_piece.is_a?(King) && (start_pos[1] - end_pos[1]).abs > 1
      col = (end_pos[1] == 6 ? [7,5] : [0,2])
      move_piece([start_pos[0],col.first],[start_pos[0],col.last])
    end

    #en passant logic
    if moving_piece.is_a?(Pawn) &&
      start_pos[1] - end_pos[1] != 0 &&
      self[end_pos] == NullP.instance
        self[[start_pos[0], end_pos[1]]] = NullP.instance
    end

    moving_piece.position = end_pos
    moving_piece.moved = true
    self[end_pos] = moving_piece
    self[start_pos] = NullP.instance

    #promotion
    if moving_piece.is_a?(Pawn) &&
      end_pos[0] == (moving_piece.color == :black ? 7 : 0)
      puts 'Promotion time!'
      promote(end_pos)
    end
  end


  def promote(pos)
    puts "#{players[0].name}, choose a piece to replace your pawn."
    puts "You may type `Queen`, `Rook`, `Knight`, or `Bishop`"
    piece_name = gets.chomp
    p self[pos]
    p players[0].color
    self[pos] = Kernel.const_get(piece_name).new(players[0].color, pos, self)
  end




  def move_piece!(start_pos, end_pos)
    validate!(start_pos, end_pos)
    moving_piece = self[start_pos]
    moving_piece.position = end_pos
    self[end_pos] = moving_piece
    self[start_pos] = NullP.instance
  end

  def validate!(start_pos, end_pos)
    raise StartPosError if self[start_pos]==NullP.instance
    raise EndPosError unless Board.valid_pos?(end_pos)
  end

  def self.valid_pos?(pos)
    row, col = pos
    row.between?(0,7) && col.between?(0,7)
  end



  def in_check?(color)
    opp_color = (color==:black ? :light_white : :black)
    king_pos = ALL_POSITIONS.select do |pos|
      self[pos].is_a?(King) && self[pos].color == color
    end.first

    ALL_POSITIONS.any? do |pos|
      self[pos].color == opp_color && self[pos].moves.include?(king_pos)
    end
  end

  def checkmate?(color)
    ALL_POSITIONS.each do |pos|
      if self[pos].color == color
        return false unless self[pos].valid_moves.empty?
      end
    end
    true
  end


  def dup
    new_board = Board.new

    ALL_POSITIONS.each do |pos|
      pos_class = self[pos].class
      if pos_class == NullP
        new_board[pos] = NullP.instance
      else
        color = self[pos].color
        new_board[pos] = pos_class.new(color, pos.dup, new_board)
      end
    end

    new_board
  end


  # private

  def setup
    #null pieces
    (2..5).each { |row| (0..7).each { |col| grid[row][col] = NullP.instance } }
    #white pawns
    8.times { |col| self[[6, col]] = Pawn.new(:light_white, [6, col], self) }
    #white rooks
    self[[7, 0]] = Rook.new(:light_white, [7, 0], self)
    self[[7, 7]] = Rook.new(:light_white, [7, 7], self)
    #white knights
    self[[7, 1]] = Knight.new(:light_white, [7, 1], self)
    self[[7, 6]] = Knight.new(:light_white, [7, 6], self)
    #white bishops
    self[[7, 2]] = Bishop.new(:light_white, [7, 2], self)
    self[[7, 5]] = Bishop.new(:light_white, [7, 5], self)
    #white queen
    self[[7, 3]] = Queen.new(:light_white, [7, 3], self)
    #white king
    self[[7, 4]] = King.new(:light_white, [7, 4], self)

    #black pawns
    8.times { |col| self[[1, col]] = Pawn.new(:black, [1, col], self) }
    #black rooks
    self[[0, 0]] = Rook.new(:black, [0, 0], self)
    self[[0, 7]] = Rook.new(:black, [0, 7], self)
    #black knights
    self[[0, 1]] = Knight.new(:black, [0, 1], self)
    self[[0, 6]] = Knight.new(:black, [0, 6], self)
    #black bishops
    self[[0, 2]] = Bishop.new(:black, [0, 2], self)
    self[[0, 5]] = Bishop.new(:black, [0, 5], self)
    #black queen
    self[[0, 3]] = Queen.new(:black, [0, 3], self)

    #black king
    self[[0, 4]] = King.new(:black, [0, 4], self)

  end

end
