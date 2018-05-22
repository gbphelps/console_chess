class Bishop < Piece
  include SlidingPiece

  def symbol
    "\xe2\x99\x9d"
  end
  
  protected 
  
  def move_dirs
    [:diagonal]
  end
end
