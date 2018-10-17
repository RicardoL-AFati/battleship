class Board
  attr_reader :size, :owner
  attr_accessor :board_info
  def initialize
    @owner = nil
    @size = 4
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
      @board_info[row.to_sym][column.to_i - 1] = "\u{25CF}"
    end
  end
end
