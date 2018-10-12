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

  # def test_play_calls_other_methods
  #   mocked_place_all_ships = MiniTest::Mock.new
  #   mocked_player_shot_sequence = MiniTest::Mock.new
  #   mocked_computer_shot_sequence = MiniTest::Mock.new

  #   mocked_place_all_ships.expect :call, nil
  #   @game.stub :place_all_ships, mocked_place_all_ships do
  #     @game.play
  #   end

  #   mocked_place_all_ships.verify

  #   mocked_player_shot_sequence.expect :call, nil
  #   @game.stub :player_shot_sequence, mocked_player_shot_sequence do
  #     @game.play
  #   end

  #   mocked_player_shot_sequence.verify
    
  #   mocked_computer_shot_sequence.expect :call, nil
  #   @game.stub :computer_shot_sequence, mocked_computer_shot_sequence do
  #     @game.play
  #   end
    
  #   mocked_computer_shot_sequence.verify
  # end

  def test_it_shows_instructions
    result, stdout, stderr = OStreamCatcher.catch do
      @game.show_instructions
    end
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

end
