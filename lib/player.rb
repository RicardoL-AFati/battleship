require './lib/prompts'

class Player
  LETTERS = ["A", "B", "C", "D"]

  attr_reader :board, :shot_history, :ships

  def initialize(board)
    @board = board
    @shot_history = []
    @ships = []
  end

  def valid_choice?(choice, length)
    choice_list = choice.split(" ")
    return false if not choice_list.length == length

    valid_coordinates = get_final_coordinates_if_valid(choice_list)

    return false if not valid_coordinates
    valid_coordinates
  end

  def place_ship(coordinates)
    @board.create_ship(coordinates)
    add_to_ships(coordinates)
  end

  def get_final_coordinates_if_valid(choice_list)
    on_board = valid_against_board?(choice_list)
    return false if not on_board
    doesnt_overlap = valid_against_previous_placement?(choice_list)
    consecutive = consecutive_coordinates?(choice_list)
    final = doesnt_overlap && consecutive ? choice_list : false
  end

  def valid_against_board?(choice_list)
    valid = true
    choice_list.each do |coord|
      valid = coord_inside_board?(coord)
      return false if not valid
    end
    valid
  end

  def valid_against_previous_placement?(choice_list)
    valid = true
    choice_list.each do |coord|
      valid = coord_on_board_is_empty?(coord)
      return false if not valid
    end
    valid
  end

  def coord_inside_board?(coord)
    is_valid = true
    letter, number = coord.split("")
    valid_letter = LETTERS.include?(letter)
    valid_number = number.to_i <= 4

    unless valid_letter && valid_number
      is_valid = false
    end
    is_valid
  end

  def coord_on_board_is_empty?(coord)
    letter, number = coord.split("")
    letter = letter.upcase.to_sym
    number = number.to_i
    valid = @board.board_info[letter][number - 1] == " "
  end

  def consecutive_coordinates?(coordinates)
    valid = true
    letter, number = coordinates[0].split("")
    initial = LETTERS.index(letter) + number.to_i - 1

    coordinates.reduce(initial) do |previous_value, coordinate|
      letter, number = coordinate.split("")
      current_value = LETTERS.index(letter) + number.to_i
      puts "#{current_value} current "
      puts "#{previous_value} previous "
      valid = false if not current_value == previous_value + 1
      previous_value = current_value
      previous_value
    end
    valid
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
end
