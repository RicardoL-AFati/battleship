require './test/test_helper'
require './lib/board'
require './lib/computer'

class BoardTest < Minitest::Test
  def setup
    @board = Board.new
    # board.create_ships(["A1", "A2"], ["B2", "B3", "B4"])
  end

  def test_it_exists
    assert_instance_of Board, @board
  end

  def test_it_can_add_owner
    computer = Computer.new(@board)

    @board.add_owner(computer)

    assert_instance_of Computer, @board.owner
  end

  def test_it_can_create_ship
    @board.create_ship(["A1", "A2"])
    expected = {:A=>["⛵", "⛵", " ", " "], :B=>[" ", " ", " ", " "], :C=>[" ", " ", " ", " "], :D=>[" ", " ", " ", " "]}

    assert_equal expected, @board.board_info
  end
end