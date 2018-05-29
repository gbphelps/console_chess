require 'byebug'

class Display

  attr_accessor :board, :cursor

  def initialize(board,cursor)
    @board = board
    @cursor = cursor
  end


  def render(color)
    range = (color == :light_white ? (0..7) : (0..7).to_a.reverse)

    system("clear")
    puts
    str = ""
    range.each do |row|
      str << "  "
      range.each do |col|
        str << render_square(row,col)
      end
      str << "\n"
    end
    puts str
    puts
  end











  def render_square(row,col)
    piece = board[[row,col]]
    opp_color = (piece.color == :black ? :light_white : :black)

    light_square = (row.even? == col.even?)
    dark_square = !light_square
    target = [row,col] == cursor.cursor_pos
    clicked = [row,col] == cursor.stashed

    color = [:yellow,piece.color] if light_square
    color = [:red,piece.color] if dark_square
    color = [:light_blue,opp_color] if light_square && target
    color = [:blue,opp_color] if dark_square && target
    color = [:light_cyan,:blue ] if clicked

    return "#{piece.symbol} ".colorize(:background =>color[0],:color =>color[1])
  end

end
