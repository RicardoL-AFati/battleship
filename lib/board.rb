class Board
  attr_reader :size, :owner
  attr_accessor :board_info
  def initialize(size = 4)
    @owner = nil
    @size = size
    @board_info = {
      A: [' ',' ',' '," "],
      B: [' ',' ',' ',' '],
      C: [' ',' ',' ',' '],
      D: [' ',' ',' ',' ']
    }
  end

  def add_owner(owner)
    @owner = owner
  end

  def create_ship(coordinates)
    coordinates.each do |coord|
      row, column = coord.split('')
      @board_info[row.to_sym][column.to_i - 1] = "\u{26F5}"
    end
  end
end
