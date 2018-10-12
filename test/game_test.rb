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
    io.puts "play"
    io.rewind
    $stdin = io

    @mocked_method.expect :call, nil
    @game.stub :play, mocked_method do
      @game.run
    end

    $stdin = STDIN  

    mocked_method.verify
  end
  
  def test_it_shows_prompts
    expected = "#{Prompts::WELCOME}\n#{Prompts::START}> "
    assert_equal expected, @game.show_start_prompt
  end

end
