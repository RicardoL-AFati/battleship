class Player
  LETTERS = ["A", "B", "C", "D"]

  attr_reader :board

  def initialize(board)
    @board = board
    @shot_history = []
  end

  def validate_choice(choice)
    # Player inputs choice
    # Split choice for each coord
    choice_list = choice.split(" ")
    if choice_list > 3
      # Return promt to make better choice
    end

    
    require 'pry'; binding.pry
    # Validate for ship doesn't overlap board
    # Validate doesn't overlap another ship
    # Method returns coords or false
    # Until loop based off return
  end

  def validate_against_board(choice)
    choice_list.each do |coord|
      letter, number = coord.split("")
      valid_letter = LETTERS.include?(letter)
      valid_number = number <= 4
      
      if !valid_letter || !valid_number
        return false
      end
    end
  end
end