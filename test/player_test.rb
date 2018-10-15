require './test/test_helper'
require './lib/player'
require './lib/board'
require 'o_stream_catcher'

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

  def test_it_gets_valid_player_shot
    io = StringIO.new
    io.puts "A1"
    io.rewind
    $stdin = io

    result, stdout, stderr = OStreamCatcher.catch do
      @player.get_shot
    end

    $stdin = STDIN

    assert_equal "A1", result
    assert_equal "Shot has been made...\n", stdout
  end

  def test_it_can_validate_placement_choice
    choice = "B2 B3 B4"
    assert_equal ["B2", "B3", "B4"], @player.valid_choice?(choice, 3)
  end

  def test_it_returns_false_if_placement_is_overboard
    bad_choice = "B3 B4 B5"

    refute @player.valid_choice?(bad_choice, 3)
  end

  def test_it_can_validate_placement_doesnt_overlap
    @player.board.create_ship(['A1', 'B1'])
    choice = "A2 A3 A4"

    assert_equal ["A2", "A3", "A4"], @player.valid_choice?(choice, 3)
  end

  def test_it_returns_false_if_placement_overlaps_previous_ship
    @player.board.create_ship(['A1', 'B1'])
    bad_choice = "A1 A2 A3"

    refute @player.valid_choice?(bad_choice, 3)
  end

  def test_it_checks_for_consecutive_coordinates_valid_horizontal_two_length
    coordinates = ["A1", "A2"]

    assert @player.consecutive_coordinates?(coordinates)
  end

  def test_it_checks_for_consecutive_coordinates_valid_horizontal_three_length
    coordinates = ["A1", "A2", "A3"]

    assert @player.consecutive_coordinates?(coordinates)
  end

  def test_it_checks_for_consecutive_coordinates_valid_vertical_two_length
    coordinates = ["A1", "B1"]

    assert @player.consecutive_coordinates?(coordinates)
  end

  def test_it_checks_for_consecutive_coordinates_valid_vertical_three_length
    coordinates = ["A1", "B1", "C1"]

    assert @player.consecutive_coordinates?(coordinates)
  end

  def test_it_checks_for_consecutive_coordinates_invalid_missing_coordinate
    coordinates = ["A1", "C1"]

    refute @player.consecutive_coordinates?(coordinates)
  end

  def test_it_checks_for_consecutive_coordinates_invalid_random_coordinates
    coordinates = ["A1", "D4"]

    refute @player.consecutive_coordinates?(coordinates)
  end

  def test_it_checks_for_consecutive_coordinates_invalid_repeating_coordinates
    coordinates = ["A1", "A1"]

    refute @player.consecutive_coordinates?(coordinates)
  end

  def test_it_checks_for_consecutive_coordinates_invalid_diagnol_coordinates
    coordinates = ["A1", "B2", "C3"]

    refute @player.consecutive_coordinates?(coordinates)
  end

  def test_it_checks_for_consecutive_coordinates_invalid_reverse_coordinates
    coordinates = ["C3", "C2", "C1"]

    refute @player.consecutive_coordinates?(coordinates)
  end

  def test_it_gets_player_two_length_ship_coordinates_with_valid_coordinates
    io = StringIO.new
    io.puts "A1 A2"
    io.rewind
    $stdin = io

    result, stdout, stderr = OStreamCatcher.catch do
      @player.get_ship_coordinates(2)
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
      @player.get_ship_coordinates(2)
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
      @player.get_ship_coordinates(3)
    end

    $stind = STDIN

    assert_equal result, ["A1", "A2", "A3"]
    assert_equal stdout, "\"Enter the squares for a 3-unit ship\"\nThat ship has been placed!\n"
  end

  def test_it_adds_to_ships
    ship_1_coordinates = ["A1", "A2"]

    @player.add_to_ships(ship_1_coordinates)
    assert_equal 1, @player.ships.length
    assert_equal 2, @player.ships[0].length
  end

end
