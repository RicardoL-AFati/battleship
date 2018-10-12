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

  def start_game
    # show_start_prompt
    # choice = gets.chomp
    # if choice == "p"
    #   play
    # end
    play
  end

  def play
    @watson.place_ships
    # show_player_turn_promt(2)
    ship_1 = get_player_ship_coordinates(2)
    ship_2 = get_player_ship_coordinates(3)
    @player.place_ship(ship_1)
    @player.place_ship(ship_2)
    render_player_shot_board
  end

  def get_player_ship_coordinates(length)
    p "Place #{length} length ship"
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

  def render_player_shot_board
    p "==========="
    p ". 1 2 3 4" 
    p "A          "
    p "B          "
    p "C          "
    p "D          "
    puts " "
    
    p "==========="
    nil
  end
end
