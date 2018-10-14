require './test/test_helper'
require 'stringio'
require 'o_stream_catcher'
require './lib/game'
require './lib/computer'
require './lib/player'
require './lib/board'
require './lib/prompts'
require 'pry'

class GameTest < Minitest::Test
  def setup
    @game = Game.new
    @mocked_method = MiniTest::Mock.new
  end

  def test_it_exists
    assert_instance_of Game, @game
  end

  def test_it_has_a_player
    assert_instance_of Player, @game.player
  end

  def test_it_has_a_computer
    assert_instance_of Computer, @game.watson
  end

  def test_player_and_watson_have_seperate_boards
    refute_equal @game.player.board, @game.watson.board
  end

  def test_it_runs_and_calls_play_on_p_input
    io = StringIO.new
    io.puts "p"
    io.rewind
    $stdin = io

    @mocked_method.expect :call, nil
    @game.stub :play, @mocked_method do
      @game.run
    end

    $stdin = STDIN

    @mocked_method.verify
  end

  def test_it_runs_and_calls_play_on_play_input
    io = StringIO.new
    io.puts "play"
    io.rewind
    $stdin = io

    @mocked_method.expect :call, nil
    @game.stub :play, @mocked_method do
      @game.run
    end

    $stdin = STDIN

    @mocked_method.verify
  end

  def test_it_runs_and_calls_show_instructions_on_i_input
    io = StringIO.new
    io.puts "i"
    io.rewind
    $stdin = io

    @mocked_method.expect :call, nil
    @game.stub :show_instructions, @mocked_method do
      @game.run
    end

    $stdin = STDIN

    @mocked_method.verify
  end

  def test_it_runs_and_calls_show_instructions_on_instructions_input
    io = StringIO.new
    io.puts "instructions"
    io.rewind
    $stdin = io

    @mocked_method.expect :call, nil
    @game.stub :show_instructions, @mocked_method do
      @game.run
    end

    $stdin = STDIN

    @mocked_method.verify
  end

  def test_it_runs_and_calls_quit_on_q_input
    io = StringIO.new
    io.puts "q"
    io.rewind
    $stdin = io

    @mocked_method.expect :call, nil
    @game.stub :quit, @mocked_method do
      @game.run
    end

    $stdin = STDIN

    @mocked_method.verify
  end

  def test_it_runs_and_calls_quit_on_quit_input
    io = StringIO.new
    io.puts "quit"
    io.rewind
    $stdin = io

    @mocked_method.expect :call, nil
    @game.stub :quit, @mocked_method do
      @game.run
    end

    $stdin = STDIN

    @mocked_method.verify
  end

  def test_play_calls_other_methods
    skip
    # all out of expects
    mocked_place_all_ships = MiniTest::Mock.new
    mocked_player_shot_sequence = MiniTest::Mock.new
    mocked_computer_shot_sequence = MiniTest::Mock.new

    mocked_place_all_ships.expect :call, nil
    mocked_player_shot_sequence.expect :call, nil
    mocked_computer_shot_sequence.expect :call, nil
    @game.stub :place_all_ships, mocked_place_all_ships do
      @game.stub :player_shot_sequence, mocked_player_shot_sequence do
        @game.stub :computer_shot_sequence, mocked_computer_shot_sequence do
          @game.play
        end
      end
    end

    mocked_place_all_ships.verify
    mocked_player_shot_sequence.verify
    mocked_computer_shot_sequence.verify
  end

  def test_it_gets_player_two_length_ship_coordinates_with_valid_coordinates
    io = StringIO.new
    io.puts "A1 A2"
    io.rewind
    $stdin = io

    result, stdout, stderr = OStreamCatcher.catch do
      @game.get_player_ship_coordinates(2)
    end

    $stind = STDIN

    assert_equal result, ["A1", "A2"]
    assert_equal stdout, "\"Enter the squares for a 2-unit ship\"\nThat ship has been placed!\n"
  end

  def test_it_gets_player_two_length_ship_coordinates_with_invalid_coordinates
    skip
    io = StringIO.new
    io.puts "A1 A5"
    io.rewind
    $stdin = io

    result, stdout, stderr = OStreamCatcher.catch do
      @game.get_player_ship_coordinates(2)
    end

    $stind = STDIN
    assert_equal stdout,
    "\"Incorrect, remember to place your ship on the grid of A-D and 1-4 and dont overlap ships.\"\nThat ship has been placed!\n"
  end

  def test_it_gets_player_three_length_ship_coordinates_with_valid_coordinates
    io = StringIO.new
    io.puts "A1 A2 A3"
    io.rewind
    $stdin = io

    result, stdout, stderr = OStreamCatcher.catch do
      @game.get_player_ship_coordinates(3)
    end

    $stind = STDIN

    assert_equal result, ["A1", "A2", "A3"]
    assert_equal stdout, "\"Enter the squares for a 3-unit ship\"\nThat ship has been placed!\n"
  end

  def test_it_shows_instructions
    mocked_run = MiniTest::Mock.new
    mocked_run.expect :call, nil

    result, stdout, stderr = OStreamCatcher.catch do
      @game.stub :run, mocked_run do
        @game.show_instructions
      end
    end

    mocked_run.verify

    assert_equal stdout, "#{Prompts::INSTRUCTIONS}\n"
  end

  def test_it_quits
    result, stdout, stderr = OStreamCatcher.catch do
      @game.quit
    end
    assert_equal stdout, "k bai \u{1F630}\n"
  end

  def test_it_shows_prompts
    expected = "#{Prompts::WELCOME}\n#{Prompts::START}> "
    assert_equal expected, @game.show_start_prompt
  end

  def test_it_gets_valid_player_shot
    io = StringIO.new
    io.puts "A1"
    io.rewind
    $stdin = io

    result, stdout, stderr = OStreamCatcher.catch do
      @game.get_player_shot
    end

    $stdin = STDIN

    assert_equal "A1", result
    assert_equal "Shot has been made...\n", stdout
  end

  def test_it_calls_other_methods_when_placing_player_shot_hit
    @game.watson.board.board_info[:A][1] = "\u{26F5}"

    mocked_update_board = MiniTest::Mock.new
    mocked_update_ships = MiniTest::Mock.new
    mocked_give_feedback = MiniTest::Mock.new

    mocked_update_board.expect(:call, nil,[:A, 2, true, @game])
    mocked_update_board.expect(:call, nil,[:A, 2, true, @game.watson])
    mocked_update_ships.expect(:call, false,["A2", @game.watson])
    mocked_give_feedback.expect(:call, nil,[true, "A2", false])
    @game.stub :update_board, mocked_update_board do
      @game.stub :update_ships, mocked_update_ships do
        @game.stub :give_feedback, mocked_give_feedback do
          @game.place_shot('A2', @game.watson)
        end
      end
    end

    mocked_update_board.verify
    mocked_update_board.verify
    mocked_update_ships.verify
    mocked_give_feedback.verify
  end

  def test_it_calls_other_methods_when_placing_player_shot_miss
    @game.watson.board.board_info[:A][1] = " "

    mocked_update_board = MiniTest::Mock.new
    mocked_give_feedback = MiniTest::Mock.new

    mocked_update_board.expect(:call, nil,[:A, 2, false, @game])
    mocked_update_board.expect(:call, nil,[:A, 2, false, @game.watson])
    mocked_give_feedback.expect(:call, nil,[false, "A2", false])
    @game.stub :update_board, mocked_update_board do
      @game.stub :give_feedback, mocked_give_feedback do
        @game.place_shot('A2', @game.watson)
      end
    end

    mocked_update_board.verify
    mocked_update_board.verify
    mocked_give_feedback.verify
  end

  def test_it_gives_feedback_if_shot_was_a_hit
    result, stdout, stderr = OStreamCatcher.catch do
      @game.give_feedback(true, "B4", false)
    end
    assert_equal "#{Prompts::BOAT_HIT % "B4"}\n", stdout
  end

  def test_it_gives_feedback_if_shot_was_a_miss
    result, stdout, stderr = OStreamCatcher.catch do
      @game.give_feedback(false, "B4", false)
    end
    assert_equal "#{Prompts::BOAT_MISS % "B4"}\n", stdout
  end

  def test_it_updates_watsons_board_with_a_miss
    assert_equal " ", @game.watson.board.board_info[:A][1]

    @game.update_board(:A, 2, false, @game.watson)

    assert_equal "M", @game.watson.board.board_info[:A][1]
  end

  def test_it_updates_watsons_board_with_a_hit
    assert_equal " ", @game.watson.board.board_info[:A][1]

    @game.update_board(:A, 2, true, @game.watson)

    assert_equal "H", @game.watson.board.board_info[:A][1]
  end

  def test_it_updates_game_board_with_a_miss
    assert_equal " ", @game.board.board_info[:A][1]

    @game.update_board(:A, 2, false, @game)

    assert_equal "M", @game.board.board_info[:A][1]
  end

  def test_it_updates_game_board_with_a_hit
    assert_equal " ", @game.board.board_info[:A][1]

    @game.update_board(:A, 2, true, @game)

    assert_equal "H", @game.board.board_info[:A][1]
  end

  def test_it_updates_ships
    @game.watson.ships << {A1: false, A2: false}
    @game.watson.ships << {B1: false, C1: false, D1: false}

    refute @game.watson.ships[0][:A2]
    @game.update_ships("A2", @game.watson)
    assert @game.watson.ships[0][:A2]
  end

  def test_it_returns_false_if_ship_was_not_sunk
    @game.watson.ships << {A1: true, A2: false}
    @game.watson.ships << {B1: false, C1: false, D1: false}

    refute @game.sunk_boat?("A1", @game.watson)
  end

  def test_it_renders_new_updated_board
    @game.board.board_info[:B][2] = "M"

    new_board, stdout, stderr = OStreamCatcher.catch do
      @game.render_new_board(@game)
    end

    expected = "#{Prompts::PLAYER_SHOTS}#{Prompts::TOP}#{new_board}#{Prompts::BOTTOM}"

    result, stdout, stderr = OStreamCatcher.catch do
      @game.render_new_board(@game)
    end

    assert_equal expected, stdout
  end

  def test_it_checks_for_all_ships_sunk
    @game.watson.ships << {A1: false, A2: true}
    @game.watson.ships << {B1: true, C1: true, D1: true}

    refute @game.all_ships_sunk?(@game.watson)

    @game.watson.ships[0][:A1] = true

    assert @game.all_ships_sunk?(@game.watson)
  end

  def test_computer_sequence_runs_other_methods
    skip
    skip
    # integration test
  end

  def test_it_finds_valid_shot_positions
    @game.watson.shot_history << "A2"

    result = @game.find_valid_shot_positions

    expected = ["A1", "A3", "A4", "B1", "B2", "B3", "B4", "C1", "C2", "C3", "C4", "D1", "D2", "D3", "D4"]

    assert_equal expected, result
  end
end
