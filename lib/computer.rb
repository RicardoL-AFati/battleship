require 'pry'
require './lib/board'

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

  def get_coordinates(ship_length, previous_ship = false)
    direction = DIRECTIONS[rand(2)]
    letter, number = generate_start_coordinate(direction, ship_length)
    puts "#{direction} #{letter} #{number}"
    if previous_ship
      if not valid_coordinate?(letter.to_sym, number)
        letter, number = generate_valid_start_coordinate(ship_length)
      end
      coordinates = generate_coordinates(letter, number, direction, ship_length)
      if not valid_coordinates?(coordinates)
        coordinates = generate_valid_coordinates(letter, number, direction, ship_length)
      end
    else
      coordinates = generate_coordinates(letter, number, direction, ship_length)
    end
    coordinates
  end

  def generate_start_coordinate(direction, ship_length)
     valid_positions = find_valid_positions
     if direction == :H
       coordinates = valid_positions.select do |position|
         letter, number = position.split('')
         number.to_i <= (@board.size - ship_length) + 1
       end
       coordinates[rand(coordinates.count)]
     else
       coordinates = valid_positions.select do |position|
         letter, number = position.split('')
         LETTERS[0..(@board.size - ship_length)].include?(letter)
       end
       coordinates[rand(coordinates.count)]
     end
  end

  def find_valid_positions
    valid_positions = []
    @board.board_info.each do |key, values|
      values.each_with_index do |value, index|
        if value == " "
          valid_positions << "#{key}#{index + 1}"
        end
      end
    end

    valid_positions
  end

  # def generate_start_coordinate(direction, ship_length)
  #   if direction == :H
  #     letter = LETTERS[rand(4)]
  #     number = generate_random_number(ship_length)
  #   else
  #     number = rand(4) + 1
  #     letter = generate_random_letter(ship_length)
  #   end
  #   return letter, number
  # end

  def generate_coordinates(letter, number, direction, ship_length)
    letter_start_index = LETTERS.index(letter)
    coordinates = ["#{letter}#{number}"]
    (1..ship_length - 1).each do |i|
      if direction == :H
        number += 1
        coordinates << "#{letter}#{number}"
      else
        letter = LETTERS[letter_start_index += 1]
        coordinates << "#{letter}#{number}"
      end
    end
    coordinates
  end
end

board = Board.new
apple = Computer.new(board)

apple.get_coordinates(3)
