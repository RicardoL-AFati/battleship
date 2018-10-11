require './test/test_helper'
require 'stringio'
require 'o_stream_catcher'
require './lib/game'
require './lib/prompts'
require 'pry'

class GameTest < Minitest::Test
  def setup
    @game = Game.new
  end

  def test_it_exists
    assert_instance_of Game, @game
  end

  def test_start_game_calls_play_if_valid_input_p
    mocked_method = MiniTest::Mock.new
    mocked_method.expect :call, 4
    @game.stub :play, mocked_method do
      @game.start_game
    end

    mocked_method.verify
  end

  def test_it_shows_prompts
    expected = "#{Prompts::WELCOME}\n#{Prompts::START}> "
    assert_equal expected, @game.show_start_prompt
  end

end
