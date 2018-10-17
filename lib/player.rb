require './lib/prompts'

class Player
  LETTERS = ["A", "B", "C", "D"]

  attr_reader :board, :shot_history, :ships

  def initialize(board)
    @board = board
    @shot_history = []
    @ships = []
  end

  def get_shot
    shot = gets.chomp
    valid = coord_inside_board?(shot)
    until valid
      puts "Incorrect, remember to place your shot on the grid of A-D and 1-4."
      shot = gets.chomp
      valid = coord_inside_board?(shot)
    end

    puts 'Shot has been made...'
    shot
  end

  def get_ship_coordinates(length)
    p Prompts::GET_PLAYER_COORDINATE % length.to_s
    ship_choice = gets.chomp
    valid_choice = valid_choice?(ship_choice, length)
    until valid_choice
      puts "Incorrect, remember to place your ship on the grid of A-D and 1-4 and dont overlap ships."
      ship_choice = gets.chomp
      valid_choice= valid_choice?(ship_choice, length)
    end

    puts 'That ship has been placed!'
    valid_choice
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
    doesnt_overlap && consecutive ? choice_list : false
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
    letter, number = coord.split("")
    valid_letter = LETTERS.include?(letter)
    valid_number = number.to_i <= 4

    valid_letter && valid_number
  end

  def coord_on_board_is_empty?(coord)
    letter, number = coord.split("")
    letter = letter.upcase.to_sym
    number = number.to_i
    @board.board_info[letter][number - 1] == " "
  end

  def consecutive_coordinates?(coordinates)
    valid = true
    letter, number = coordinates[0].split("")
    initial = LETTERS.index(letter) + number.to_i - 1

    coordinates.reduce(initial) do |previous_value, coordinate|
      letter, number = coordinate.split("")
      current_value = LETTERS.index(letter) + number.to_i
      valid = false if not current_value == previous_value + 1
      previous_value = current_value
      previous_value
    end
    valid
  end

  def add_to_ships(*ships_coordinates)
    ships_coordinates.each do |ship_coordinates|
      @ships << ship_coordinates.reduce({}) do |ship, coordinate|
        ship[coordinate.to_sym] = false
        ship
      end
    end
  end
end
