class Computer
  LETTERS = ["A","B","C","D"]
  DIRECTIONS = [:H, :V]
  attr_reader :board
  def initialize(board)
    @board = board
    @shot_history = []
    assign_board_owner
  end

  def assign_board_owner
    @board.add_owner(self)
  end

  def get_coordinates(ship_length)
    valid_positions = find_valid_positions
    valid_coordinates = false
    until valid_coordinates
      direction = DIRECTIONS[rand(2)]
      letter, number = generate_start_coordinate(direction, ship_length, valid_positions)
      valid_coordinates = generate_other_coordinates(letter, number, direction, ship_length, valid_positions)
    end
    valid_coordinates
  end

  def generate_start_coordinate(direction, ship_length, valid_positions)
     if direction == :H
       coordinates = valid_positions.select do |position|
         letter, number = position.split('')
         number.to_i <= (@board.size - ship_length) + 1
       end
     else
       coordinates = valid_positions.select do |position|
         letter, number = position.split('')
         LETTERS[0..(@board.size - ship_length)].include?(letter)
       end
     end
     letter, number = coordinates[rand(coordinates.count)].split("")
     return letter, number.to_i
  end

  def generate_other_coordinates(letter, number, direction, ship_length, valid_positions)
    letter_start_index = LETTERS.index(letter)
    coordinates = ["#{letter}#{number}"]
    (1..ship_length - 1).each do
      if direction == :H
        number += 1
        coordinate = "#{letter}#{number}"
      else
        letter = LETTERS[letter_start_index += 1]
        coordinate = "#{letter}#{number}"
      end
      return false if not valid_positions.include?(coordinate)
      coordinates << coordinate
    end
    coordinates
  end
  
  def find_valid_positions
    @board.board_info.reduce([]) do |valid, (row,spots)|
      spots.each_with_index do |spot, index|
        valid << "#{row}#{index + 1}" if spot == " "
      end
      valid
    end
  end
end
