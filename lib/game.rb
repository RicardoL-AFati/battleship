require './lib/prompts'
require './lib/computer'
require './lib/player'
require './lib/board'

require 'pry'

class Game
  attr_reader :player, :watson, :board, :start_time
  def initialize
   @player = Player.new(Board.new)
   @watson = Computer.new(Board.new)
   @board = Board.new
   @start_time = nil
  end

  def show_start_prompt
    start_prompt = "#{Prompts::WELCOME}\n#{Prompts::START}> "
    print start_prompt
    start_prompt
  end

  def run
    show_start_prompt
    input = gets.chomp
    sanitized_input = input.downcase
    play if sanitized_input == "p" || sanitized_input == "play"
    show_instructions if sanitized_input == "i" || sanitized_input == "instructions"
    quit if sanitized_input == "q" || sanitized_input == "quit"
    run
  end

  def play
    @start_time = Time.new
    place_all_ships
    player_won, computer_won = false, false
    until player_won || computer_won
      print Prompts::PLAYER_TURN
      player_won = player_shot_sequence
      print_game_result_screen(@player) if player_won
      print Prompts::COMPUTER_TURN
      computer_won = computer_shot_sequence
    end

    print_game_result_screen(@watson)
  end

  def show_instructions
    puts Prompts::INSTRUCTIONS
    run
  end

  def quit
    puts "k bai \u{1F630}"
    exit
  end

  def player_shot_sequence
    puts "Make your shot by entering a single coordinate:"
    valid_shot = @player.get_shot
    place_shot(valid_shot, @watson)
    add_to_shot_history(valid_shot, @player)
    render_new_board(self)
    puts Prompts::PRESS_ENTER
    key_press = gets
    until key_press == "\n"
      puts Prompts::PRESS_ENTER
      key_press = gets
    end
    all_ships_sunk?(@watson)
  end

  def computer_shot_sequence
    valid_shots = find_valid_shot_positions
    shot = valid_shots.shuffle[0]
    smart_shot = @watson.place_smart_shot(valid_shots) if @watson.successful_shot
    shot = smart_shot if smart_shot
    place_shot(shot, @player)
    add_to_shot_history(shot, @watson)
    render_new_board(@player)
    all_ships_sunk?(@player)
  end

  def place_shot(shot, opponent)
    letter, number = convert_to_letter_and_number(shot)
    boat_hit = check_for_boat_hit(letter, number, opponent)

    sunk_boat_length = process_boat_hit(shot, opponent) if boat_hit

    update_output(letter, number, boat_hit, opponent, sunk_boat_length, shot)
    boat_hit
  end

  def update_output(letter, number, boat_hit, opponent, sunk_boat_length, shot)
    update_board(letter, number, boat_hit, self) if opponent == @watson
    update_board(letter, number, boat_hit, opponent)
    give_feedback(boat_hit, shot, sunk_boat_length)
  end

  def process_boat_hit(shot, opponent)
    @watson.successful_shot = shot if opponent == @player
    sunk_boat_length = update_ships(shot, opponent)
    @watson.successful_shot = false if sunk_boat_length && opponent == @player
    sunk_boat_length
  end

  def check_for_boat_hit(letter, number, opponent)
    coordinate = opponent.board.board_info[letter][number - 1]
    coordinate == "\u{25CF}"
  end

  def convert_to_letter_and_number(shot)
    letter, number = shot.split('')
    letter = letter.upcase.to_sym
    number = number.to_i

    return letter, number
  end

  def add_to_shot_history(shot, owner)
    owner.shot_history << shot
  end

  def give_feedback(boat_hit, shot, sunk_boat_length)
    if boat_hit
      puts Prompts::BOAT_HIT % shot
    else
      puts Prompts::BOAT_MISS % shot
    end
    puts Prompts::SUNK_BOAT % sunk_boat_length if sunk_boat_length
  end

  def update_board(letter, number, boat_hit, owner)
    owner.board.board_info[letter][number - 1 ] = boat_hit ? "H" : "M"
  end

  def update_ships(shot, owner)
    shot = shot.upcase
    owner.ships.each do |ship|
      ship[shot.to_sym] = true if ship.keys.include?(shot.to_sym)
    end
    sunk_boat?(shot, owner)
  end

  def place_all_ships
    @watson.place_ships
    ship_1 = @player.get_ship_coordinates(2)
    ship_2 = @player.get_ship_coordinates(3)
    @player.place_ship(ship_1)
    @player.place_ship(ship_2)
    Prompts.print_empty_board
  end

  def render_new_board(owner)
    new_board = owner.board.board_info.reduce("") do |board_string, (row_name, columns)|
      printable_row = columns.reduce("") do |row_string, spot|
        row_string += "#{spot} "
        row_string
      end
      board_string += "#{row_name.to_s} #{printable_row} \n"
      board_string
    end
    title = owner == @player ? Prompts::PLAYER_BOARD : Prompts::PLAYER_SHOTS
    print "#{title}#{Prompts::TOP}#{new_board}#{Prompts::BOTTOM}"
    new_board
  end

  def find_valid_shot_positions
    @player.board.board_info.reduce([]) do |valid, (row,spots)|
      spots.each_with_index do |spot, index|
        valid << "#{row}#{index + 1}" if not @watson.shot_history.include?("#{row}#{index + 1}")
      end
      valid
    end
  end

  def all_ships_sunk?(owner)
    owner.ships.reduce(true) do |game_over, ship|
      game_over = false if ship.values.include?(false)
      game_over
    end
  end

  def sunk_boat?(shot, owner)
    hit_ship_index = owner.ships.find_index do |ship|
      ship.keys.include?(shot.upcase.to_sym)
    end

    sunk = owner.ships[hit_ship_index].reduce(true) do |sunk, (coordinate, hit)|
      sunk = false if not hit
      sunk
    end

    return false if not sunk
    owner.ships[hit_ship_index].length
  end

  def print_game_result_screen(winner)
    if winner == @player
      puts Prompts::WIN_SCREEN
    else
      puts Prompts::LOSE_SCREEN
    end
    puts Prompts::SHOT_COUNT % winner.shot_history.count
    time_taken = show_game_time(Time.new)
    puts Prompts::TIME_TAKEN % time_taken
    exit
  end

  def show_game_time(now)
    time_diff = now - @start_time
    convert_seconds(time_diff.round)
  end

  def convert_seconds(seconds, minutes = 0)
    if seconds <= 60
      return "#{minutes} minutes and #{seconds} seconds"
    end

    min = minutes + 1
    sec = seconds - 60
    convert_seconds(sec, min)
  end
end
