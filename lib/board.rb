class Board
  def initialize(size = 4)
    @owner = nil
    @size = size
    @board_info = {
      a: [' ',' ',' ',' '],
      b: [' ',' ',' ',' '],
      c: [' ',' ',' ',' '],
      d: [' ',' ',' ',' ']
    }
    @ships = []
  end

  def add_owner(owner)
    @owner = owner
  end
end
