require 'singleton'


class NullP < Piece
  include Singleton
  
  def initialize
    @color = nil
  end
  
  def symbol
    " "
  end
end