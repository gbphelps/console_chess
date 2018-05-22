require 'byebug'
module SlidingPiece
  DIAGONAL = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
  CARDINAL = [[1, 0], [-1, 0], [0, 1], [0, -1]]
  MOVE_TYPES = {diagonal: DIAGONAL, cardinal: CARDINAL}
  
  def moves
    move_list = []
    increments = []
    move_dirs.each {|type| increments += MOVE_TYPES[type]}
    increments.each {|increment| move_list += move_dir(increment)}  
    move_list
  end
  
  def move_dir(increment)
    moves = []
    row, col = position

    while true
      row += increment[0]
      col += increment[1]
      break unless Board.valid_pos?([row, col]) 
      space = board[[row, col]]

      if space == NullP.instance
        moves << [row, col]
        next
      else
        moves << [row, col] if space.color != color
        break
      end
    end

    moves
  end  
end

