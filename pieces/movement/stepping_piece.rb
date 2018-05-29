module SteppingPiece

require 'byebug'
  KNIGHT = [[2, 1], [2, -1], [-2, 1], [-2, -1], [1, 2], [1, -2], [-1, 2], [-1, -2]]
  KING = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]

  def moves
    move_list = []
    increments = (is_a?(Knight) ? KNIGHT : KING)
    increments.each do |increment|
      row = position[0] + increment[0]
      col = position[1] + increment[1]
      pos = [row, col]

      move_list << pos if Board.valid_pos?(pos) && board[pos].color != color
    end

    return move_list + castle if is_a?(King)

    move_list
  end

  def castle
    castles = []
    row = (color == :light_white ? 7 : 0)

    left = [[row,1],[row,2],[row,3]]
    right = [[row,6],[row,5]]
    clear_left = left.all? {|pos| board[pos] == NullP.instance}
    clear_right = right.all? {|pos| board[pos] == NullP.instance}

    if board[[row,0]].moved == false
      castles << [row,1] if clear_left
    end

    if board[[row,7]].moved == false
      castles << [row,6] if clear_right
    end

    castles
  end

end
