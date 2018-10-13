require './lib/prompts'

class Player
  LETTERS = ["A", "B", "C", "D"]

  attr_reader :board, :shot_history

  def initialize(board)
    @board = board
    @shot_history = []
    @ships = []
  end


  def valid_choice?(choice, second_choice = nil)
    choice_list = choice.split(" ")
    return false if choice_list.length > 3

    valid_coordinates = get_final_coordinates_if_valid(choice_list)

    return false if not valid_coordinates
    valid_coordinates
  end

  def place_ship(coordinates)
    @board.create_ship(coordinates)
  end

  def get_final_coordinates_if_valid(choice_list)
    on_board = valid_against_board?(choice_list)
    return false if not on_board
    doesnt_overlap = valid_against_previous_placement?(choice_list)
    final = on_board && doesnt_overlap ? choice_list : false
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
end
