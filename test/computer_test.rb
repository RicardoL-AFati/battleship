require './test/test_helper'
require './lib/computer'
require './lib/board'
require 'pry'
class ComputerTest < Minitest::Test
  def setup
    @board = Board.new
    @computer = Computer.new(@board)
  end

  def test_it_generates_start_coordinate_length_of_two

  end
  def test_it_generates_coordinates_for_horizontal_placement_length_two_row_a
    assert_equal ["A1", "A2"], @computer.generate_coordinates("A", 1, :H, 2)
  end

  def test_it_generates_coordinates_for_horizontal_placement_length_two_row_b
    assert_equal ["B1", "B2"], @computer.generate_coordinates("B", 1, :H, 2)
  end

  def test_it_generates_coordinates_for_horizontal_placement_length_three_row_a
    assert_equal ["A1", "A2", "A3"], @computer.generate_coordinates("A", 1, :H, 3)
  end

  def test_it_generates_coordinates_for_horizontal_placement_length_three_row_b
    assert_equal ["B1", "B2", "B3"], @computer.generate_coordinates("B", 1, :H, 3)
  end

  def test_it_generates_coordinates_for_vertical_placement_length_two_column_1
    assert_equal ["A1", "B1"], @computer.generate_coordinates("A", 1, :V, 2)
  end

  def test_it_generates_coordinates_for_vertical_placement_length_two_column_2
    assert_equal ["A2", "B2"], @computer.generate_coordinates("A", 2, :V, 2)
  end

  def test_it_generates_coordinates_for_vertical_placement_length_three_column_1
    assert_equal ["A1", "B1", "C1"], @computer.generate_coordinates("A", 1, :V, 3)
  end

  def test_it_generates_coordinates_for_vertical_placement_length_three_column_2
    assert_equal ["A2", "B2", "C2"], @computer.generate_coordinates("A", 2, :V, 3)
  end

  def test_generates_random_letter_length_of_three
    assert /[AB]/ =~ @computer.generate_random_letter(3)
  end

  def test_generates_random_letter_length_of_two
    assert /[ABC]/ =~ @computer.generate_random_letter(2)
  end

  def test_generates_random_number_length_of_three
    assert /[12]/ =~ @computer.generate_random_number(3).to_s
  end

  def test_generates_random_number_length_of_two
    assert /[123]/ =~ @computer.generate_random_number(2).to_s
  end
end
