class Rook < Piece
  include SlidingPiece

  def symbol
    "\xe2\x99\x9c"
  end

  protected

  def move_dirs
    [:cardinal]
  end
end
