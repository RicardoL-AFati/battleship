class Board
  attr_reader :size
  def initialize(size = 4)
    @owner = nil
    @size = size
    @board_info = {
      A: [' ',' ',' '," "],
      B: [' ',' ',' ',' '],
      C: [' ',' ',' ',' '],
      D: [' ',' ',' ',' ']
    }
    @ships = []
  end

  def add_owner(owner)
    @owner = owner
  end
end
