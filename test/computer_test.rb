require './test/test_helper'
require './lib/computer'
require './lib/board'
require 'pry'
class ComputerTest < Minitest::Test
  def setup
    @board = Board.new
    @computer = Computer.new(@board)
  end

  def test_it_gets_coordinates_length_of_two_no_previous_ship
    coordinates = @computer.get_coordinates(2)

    assert (/[ABCD]/) =~ coordinates[0].split("")[0]
    assert (/[1234]/) =~ coordinates[0].split("")[1]
    assert (/[ABCD]/) =~ coordinates[1].split("")[0]
    assert (/[1234]/) =~ coordinates[1].split("")[1]
  end

  def test_it_gets_coordinates_length_of_three_no_previous_ship
    coordinates = @computer.get_coordinates(3)
    binding.pry
    assert (/[ABCD]/) =~ coordinates[0].split("")[0]
    assert (/[1234]/) =~ coordinates[0].split("")[1]
    assert (/[ABCD]/) =~ coordinates[1].split("")[0]
    assert (/[1234]/) =~ coordinates[1].split("")[1]
    assert (/[ABCD]/) =~ coordinates[2].split("")[0]
    assert (/[1234]/) =~ coordinates[2].split("")[1]
  end

  def test_it_gets_coordinates_length_of_three_previous_ship
    skip
    @board.board_info = {
      A: [" ","\u{26F5}","\u{26F5}","\u{26F5}"],
      B: [" ","\u{26F5}","\u{26F5}","\u{26F5}"],
      C: ["\u{26F5}","\u{26F5}","\u{26F5}","\u{26F5}"],
      D: ["\u{26F5}","\u{26F5}","\u{26F5}","\u{26F5}"]
    }
    coordinates = @computer.get_coordinates(2, true)
    assert_equal ["A1", "B1"], coordinates
  end

  def test_it_gets_coordinates_length_of_two_previous_ship
    skip
    @board.board_info = {
      A: [" ","\u{26F5}","\u{26F5}","\u{26F5}"],
      B: [" ","\u{26F5}","\u{26F5}","\u{26F5}"],
      C: [" ","\u{26F5}","\u{26F5}","\u{26F5}"],
      D: ["\u{26F5}","\u{26F5}","\u{26F5}","\u{26F5}"]
    }
    coordinates = @computer.get_coordinates(3, true)
    assert_equal ["A1", "B1", "C1"], coordinates
  end

  def test_it_generates_start_coordinate_length_of_two_horizontal
    skip
    letter, number = @computer.generate_start_coordinate(:H, 2)

    assert (/[ABCD]/) =~ letter
    assert (/[123]/) =~ number.to_s
  end

  def test_it_generates_start_coordinate_length_of_two_vertical
    skip
    letter, number = @computer.generate_start_coordinate(:V, 2)

    assert (/[ABC]/) =~ letter
    assert (/[1-4]/) =~ number.to_s
  end

  def test_it_generates_start_coordinate_length_of_three_horizontal
    skip
    letter, number = @computer.generate_start_coordinate(:H, 3)

    assert (/[ABCD]/) =~ letter
    assert (/[12]/) =~ number.to_s
  end

  def test_it_generates_start_coordinate_length_of_three_vertical
    skip
    letter, number = @computer.generate_start_coordinate(:V, 3)

    assert (/[AB]/) =~ letter
    assert (/[1-4]/) =~ number.to_s
  end
end
