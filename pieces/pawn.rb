class Pawn < Piece

  def moves
    forward_steps + side_attacks + en_passant
  end

  def move_dirs
  end

  def symbol
    "\xe2\x99\x9f"
  end

  private

  def start_row
    color == :black ? 1 : 6
  end

  def forward_dir
    color == :black ? 1 : -1
  end

  def forward_steps
    move_list = []
    one_step = [position[0] + forward_dir, position[1]]
    two_step = [position[0] + (2 * forward_dir), position[1]]

    if Board.valid_pos?(one_step) && board[one_step] == NullP.instance
      move_list << one_step
      move_list << two_step if Board.valid_pos?(two_step) && board[two_step] == NullP.instance && !moved
    end

    move_list
  end

  def side_attacks
    right_attack = [position[0] + forward_dir, position[1] + 1]
    left_attack = [position[0] + forward_dir, position[1] - 1]
    [right_attack, left_attack].select do |space|
      Board.valid_pos?(space) && board[space].color != color && board[space].color
    end
  end

  def en_passant
    eligible_row = (color == :black ? 4 : 3)
    return [] unless position[0] == eligible_row

    left_col = position[1]-1
    right_col = position[1]+1

    en_passants = []

    [left_col, right_col].each do |column|
      if board[ [position[0], column] ].is_a?(Pawn) &&
        board.history.last == [
            [position[0]+2*forward_dir, column],
            [position[0], column]
        ]
         p "#{[position[0]+forward_dir, column]} is a valid move"
         en_passants << [position[0]+forward_dir, column]
       end
    end
    return en_passants
  end

end
