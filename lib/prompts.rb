module Prompts
  WELCOME = "Welcome to BATTLESHIP!\n"
  START = "Would you like to (p)lay, read the (i)nstructions, or (q)uit?\n"
  INVALID_CHOICE = "Enter one of the letters in () or the entire word - no spaces"
  GET_PLAYER_COORDINATE = "Enter the squares for a %s-unit ship"
  TOP = "===========\n. 1 2 3 4\n"
  BOTTOM = "===========\n"
  EMPTY_BOARD = "A          \nB          \nC          \nD          \n"
  def self.print_empty_board
    print TOP 
    print EMPTY_BOARD
    print BOTTOM
  end
end
