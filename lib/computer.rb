require 'pry'
require './lib/board'

class Computer
  def initialize(board)
    @board = board
    @shot_history = []
    assign_board_owner
  end

  def assign_board_owner
    @board.add_owner(self)
  end

  def get_coordinates(ship_length, previous_ship = false)
    direction = [:H, :V][rand(2)]
    letters = ["A","B","C","D"]

    if direction == :H
      letter = letters[rand(4)]
      number_constraint = @board.size - ship_length + 1
      number = rand(number_constraint) + 1
    else
      number = rand(4) + 1
      letter_constraint = @board.size - ship_length
      letters = letters[rand(letter_constraint)]
    end
    coordinate = ["#{letter}#{number}"]
    # create method to generate following coordinates
  end
end

board = Board.new
apple = Computer.new(board)

apple.get_coordinates(3)
