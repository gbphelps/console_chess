class Queen < Piece
  include SlidingPiece

  attr_reader :move_types, :board

  def symbol
    "\xe2\x99\x9b"
  end
  
  protected 
  
  def move_dirs
    [:diagonal, :cardinal]
  end

end
