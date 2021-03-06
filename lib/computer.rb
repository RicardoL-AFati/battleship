class Computer
  LETTERS = ["A","B","C","D"]
  DIRECTIONS = [:H, :V]
  attr_reader :board, :ships, :shot_history
  attr_accessor :successful_shot, :ai_shot_count
  def initialize(board)
    @board = board
    @shot_history = []
    @ships = []
    @successful_shot = nil
    @ai_shot_count = 0
    assign_board_owner
  end

  def assign_board_owner
    @board.add_owner(self)
  end

  def place_ships
    ship_1_coordinates = get_coordinates(2)
    ship_2_coordinates = get_coordinates(3)
    add_to_ships(ship_1_coordinates, ship_2_coordinates)
    @board.create_ship(ship_1_coordinates)
    @board.create_ship(ship_2_coordinates)
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
       coordinates = get_valid_starts_for_horizontal_ship(ship_length, valid_positions)
     else
       coordinates = get_valid_starts_for_vertical_ship(ship_length, valid_positions)
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
      return false if not included_in_valid_positions?(coordinate, valid_positions)
      coordinates << coordinate
    end
    coordinates
  end

  def get_valid_starts_for_horizontal_ship(ship_length, valid_positions)
    valid_positions.select do |position|
      letter, number = position.split('')
      number.to_i <= (@board.size - ship_length) + 1
    end
  end

  def get_valid_starts_for_vertical_ship(ship_length, valid_positions)
    valid_positions.select do |position|
      letter, number = position.split('')
      LETTERS[0..(@board.size - ship_length)].include?(letter)
    end
  end

  def add_to_ships(*ships_coordinates)
    ships_coordinates.each do |ship_coordinates|
      ship = ship_coordinates.reduce({}) do |ship, coordinate|
        ship[coordinate.to_sym] = false
        ship
      end
      @ships << ship
    end
  end

  def find_valid_positions
    @board.board_info.reduce([]) do |valid, (row,spots)|
      spots.each_with_index do |spot, index|
        valid << "#{row}#{index + 1}" if spot == " "
      end
      valid
    end
  end

  def place_smart_shot(valid_positions)
    valid_shot = nil

    until valid_shot
      case ai_shot_count
        when 0
          valid_shot = down(valid_positions)
          return valid_shot if valid_shot
          @ai_shot_count += 1
        when 1
          valid_shot = right(valid_positions)
          return valid_shot if valid_shot
          @ai_shot_count += 1
        when 2
          valid_shot = up(valid_positions)
          return valid_shot if valid_shot
          @ai_shot_count += 1
        else
          valid_shot = left(valid_positions)
          return valid_shot if valid_shot
          @ai_shot_count = 0
          @successful_shot = false
          break
      end
    end
    valid_shot
  end

  def down(valid_positions)
    letter, number = successful_shot.split("")

    valid_next_letter = LETTERS[LETTERS.index(letter) + 1]
    return false if not valid_next_letter

    shot = "#{valid_next_letter}#{number}"
    return false if not included_in_valid_positions?(shot, valid_positions)
    shot
  end

  def right(valid_positions)
    letter, number = successful_shot.split("")

    number = number.to_i + 1
    return false if number > 4

    shot = "#{letter}#{number}"
    return false if not included_in_valid_positions?(shot, valid_positions)
    shot
  end

  def up(valid_positions)
    letter, number = successful_shot.split("")

    return false if LETTERS.index(letter) - 1 < 0
    valid_next_letter = LETTERS[LETTERS.index(letter) - 1]

    shot = "#{valid_next_letter}#{number}"
    return false if not included_in_valid_positions?(shot, valid_positions)
    shot
  end

  def left(valid_positions)
    letter, number = successful_shot.split("")

    number = number.to_i - 1
    return false if number < 1

    shot = "#{letter}#{number}"
    return false if not included_in_valid_positions?(shot, valid_positions)
    shot
  end

  def included_in_valid_positions?(coordinate, valid_positions)
    valid_positions.include?(coordinate)
  end
end
