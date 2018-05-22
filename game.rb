require 'byebug'
require_relative 'human_player'
require_relative 'display'
require_relative 'board'
require_relative 'cursor'
require 'colorized_string'
require_relative 'pieces'


class Game

  attr_accessor :board, :cursor, :display, :players, :last_move

  def initialize(board, cursor, display, player_one, player_two)
    board.setup
    @board = board
    @cursor = cursor
    @display = display
    @players = [player_one, player_two]
    @last_move = [0, 4]
  end

  def play
    play_turn until board.checkmate?(current_player.color)
    game_over_message
  end

  def current_player
    players[0]
  end

  private

  def play_turn

    first_pos, second_pos = nil
    while true
      cursor.toggle_off
      first_pos, second_pos = nil
      first_pos = make_selection until parse_first(first_pos)
      cursor.toggle_on
      selected_piece = cursor.board[first_pos]
      second_pos = make_selection until second_pos
      break if selected_piece.valid_moves.include?(second_pos)
    end

    board.move_piece(first_pos, second_pos)
    display.render(current_player.color)
    cursor.cursor_pos = last_move
    self.last_move = second_pos
    players.rotate!
    puts "#{current_player.name}, press enter when ready."
    gets
    cursor.invert
  end

  def make_selection
    display.render(current_player.color)
    current_player.make_move(cursor)
  end

  def parse_first(first_pos)
    (first_pos && board[first_pos].color == current_player.color &&
      !board[first_pos].valid_moves.empty?)
  end

  def game_over_message
    display.render(current_player.color)
    puts "Game Over"
  end
end

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  cursor = Cursor.new([7,4],board)
  display = Display.new(board,cursor)
  player_one = HumanPlayer.new('White', :light_white)
  player_two = HumanPlayer.new('Black', :black)
  game = Game.new(board, cursor, display, player_one, player_two)
  board.checkmate?(:light_white)
  game.play
end
