require './test/test_helper'
require './lib/computer'
require './lib/board'

class ComputerTest < Minitest::New
  def setup
    @board = Board.new
    @computer = Computer.new(@board)
  end

  def test_it_get_coordinates

  end
end
