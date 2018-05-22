class Pawn < Piece
  
  def moves
    forward_steps + side_attacks
  end
  
  def move_dirs
  end
  
  def symbol
    "\xe2\x99\x9f"
  end
  
  private
  
  def at_start_row?
    color == :black ? (position[0]==1) : (position[0]==6)
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
      move_list << two_step if board[two_step] == NullP.instance && at_start_row?
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

end
