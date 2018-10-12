require './test/test_helper'
require './lib/player'
require './lib/board'

class PlayerTest < Minitest::Test
  def setup
    @board = Board.new
    @player = Player.new(@board)
  end

  def test_it_exists
    assert_instance_of Player, @player
  end

  def test_it_has_a_board
    assert_instance_of Board, @player.board
  end

  def test_it_can_validate_player_placement_choice
    choice = "B2 B3 B4"
    
    assert_equal true, @player.validate_choice(choice)
  end

  def test_it_can_place_ships
    skip
    #integration test
  end

end