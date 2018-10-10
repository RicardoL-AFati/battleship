require './lib/prompts'
require 'pry'

class Game
  def show_start_prompt
    start_prompt = "#{Prompts::WELCOME}\n#{Prompts::START}> "
    print start_prompt
    start_prompt
  end

  def start_game
    show_start_prompt
    choice = gets.chomp
    if choice == "p"
      play
    end
  end

  def play
    puts "Playing game"
  end
end
