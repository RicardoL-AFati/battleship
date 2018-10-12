require './lib/prompts'
require './lib/computer'
require './lib/player'
require './lib/board'

require 'pry'

class Game
  attr_reader :player, :watson
  def initialize
   @player = Player.new(Board.new)
   @watson = Computer.new(Board.new)
   @shot_board = Board.new
  end

  def show_start_prompt
    start_prompt = "#{Prompts::WELCOME}\n#{Prompts::START}> "
    # print start_prompt
    start_prompt
  end

  def run
    # puts show_start_prompt
    input = gets.chomp
    sanitized_input = input.downcase
    play if sanitized_input == "p" || sanitized_input == "play"
    show_instructions if sanitized_input == "i" || sanitized_input == "instructions"
    quit if sanitized_input == "q" || sanitized_input == "quit"
  end

  def play
    place_all_ships
    player_shot_sequence
    computer_shot_sequence
  end

  def show_instructions
    puts Prompts::INSTRUCTIONS
  end

  def quit
    puts "k bai \u{1F630}"
  end

  def player_shot_sequence
    
  end

  def computer_shot_sequence
    
  end

  def place_all_ships
    @watson.place_ships
    ship_1 = get_player_ship_coordinates('two')
    ship_2 = get_player_ship_coordinates('three')
    @player.place_ship(ship_1)
    @player.place_ship(ship_2)
    Prompts.print_empty_board
  end

  def get_player_ship_coordinates(length)
    p Prompts::GET_PLAYER_COORDINATE % length
    ship_choice = gets.chomp
    valid_choice = @player.valid_choice?(ship_choice)
    until valid_choice
      p "Incorrect, remember to place your ship on the grid of A-D and 1-4 and dont overlap ships."
      ship_choice = gets.chomp
      valid_choice= @player.valid_choice?(ship_choice)
    end

    puts 'Success!'
    valid_choice
  end
end
