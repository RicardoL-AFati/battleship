require './test/test_helper'
require './lib/computer'
require './lib/board'

class ComputerTest < Minitest::Test
  def setup
    @board = Board.new
    @computer = Computer.new(@board)
    @valid_positions = ["A1", "A2", "A3", "A4", "B1", "B2", "B3", "B4", "C1", "C2", "C3", "C4", "D1", "D2", "D3", "D4"]
  end

  def test_it_gets_ship_coordinates_and_passes_to_board_for_creation
    skip
    #integration test
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

    assert (/[ABCD]/) =~ coordinates[0].split("")[0]
    assert (/[1234]/) =~ coordinates[0].split("")[1]
    assert (/[ABCD]/) =~ coordinates[1].split("")[0]
    assert (/[1234]/) =~ coordinates[1].split("")[1]
    assert (/[ABCD]/) =~ coordinates[2].split("")[0]
    assert (/[1234]/) =~ coordinates[2].split("")[1]
  end

  def test_it_gets_coordinates_length_of_three_previous_ship

    @board.board_info = {
      A: [" ","\u{25CF}","\u{25CF}","\u{25CF}"],
      B: [" ","\u{25CF}","\u{25CF}","\u{25CF}"],
      C: ["\u{25CF}","\u{25CF}","\u{25CF}","\u{25CF}"],
      D: ["\u{25CF}","\u{25CF}","\u{25CF}","\u{25CF}"]
    }

    coordinates = @computer.get_coordinates(2)
    assert_equal ["A1", "B1"], coordinates
  end

  def test_it_gets_coordinates_length_of_three_previous_ship_v2
    @board.board_info = {
      A: ["\u{25CF}","\u{25CF}","\u{25CF}","\u{25CF}"],
      B: ["\u{25CF}","\u{25CF}","\u{25CF}","\u{25CF}"],
      C: ["\u{25CF}","\u{25CF}"," ","\u{25CF}"],
      D: ["\u{25CF}","\u{25CF}"," ","\u{25CF}"]
    }
    coordinates = @computer.get_coordinates(2)
    assert_equal ["C3", "D3"], coordinates
  end

  def test_it_gets_coordinates_length_of_two_previous_ship
    @board.board_info = {
      A: [" ","\u{25CF}","\u{25CF}","\u{25CF}"],
      B: [" ","\u{25CF}","\u{25CF}","\u{25CF}"],
      C: [" ","\u{25CF}","\u{25CF}","\u{25CF}"],
      D: ["\u{25CF}","\u{25CF}","\u{25CF}","\u{25CF}"]
    }

    coordinates = @computer.get_coordinates(3)
    assert_equal ["A1", "B1", "C1"], coordinates
  end

  def test_it_gets_coordinates_length_of_two_previous_ship_v2
    @board.board_info = {
      A: ["\u{25CF}","\u{25CF}","\u{25CF}","\u{25CF}"],
      B: ["\u{25CF}"," ","\u{25CF}","\u{25CF}"],
      C: ["\u{25CF}"," ","\u{25CF}","\u{25CF}"],
      D: ["\u{25CF}"," ","\u{25CF}","\u{25CF}"]
    }
    coordinates = @computer.get_coordinates(3)
    assert_equal ["B2", "C2", "D2"], coordinates
  end

  def test_it_generates_start_coordinate_length_of_two_horizontal
    letter, number = @computer.generate_start_coordinate(:H, 2, @valid_positions)

    assert (/[ABCD]/) =~ letter
    assert (/[123]/) =~ number.to_s
  end

  def test_it_generates_start_coordinate_length_of_two_vertical
    letter, number = @computer.generate_start_coordinate(:V, 2, @valid_positions)


    assert (/[ABC]/) =~ letter
    assert (/[1-4]/) =~ number.to_s
  end

  def test_it_generates_start_coordinate_length_of_three_horizontal
    letter, number = @computer.generate_start_coordinate(:H, 3, @valid_positions)

    assert (/[ABCD]/) =~ letter
    assert (/[12]/) =~ number.to_s
  end

  def test_it_generates_start_coordinate_length_of_three_vertical
    letter, number = @computer.generate_start_coordinate(:V, 3, @valid_positions)

    assert (/[AB]/) =~ letter
    assert (/[1-4]/) =~ number.to_s
  end

  def test_it_finds_valid_positions_with_empty_board
    assert_equal @valid_positions, @computer.find_valid_positions
  end

  def test_it_finds_valid_positions_with_filled_board
    @computer.board.board_info = {
      A: ["\u{25CF}","\u{25CF}","\u{25CF}","\u{25CF}"],
      B: [" ","\u{25CF}","\u{25CF}","\u{25CF}"],
      C: [" ","\u{25CF}","\u{25CF}","\u{25CF}"],
      D: [" ","\u{25CF}","\u{25CF}","\u{25CF}"]
    }

    expected = ["B1", "C1", "D1"]

    assert_equal expected, @computer.find_valid_positions
  end


  def test_it_adds_to_ships
    ship_1_coordinates = ["A1", "A2"]
    ship_2_coordinates = ["B1", "B2", "B3"]

    @computer.add_to_ships(ship_1_coordinates, ship_2_coordinates)

    assert_equal 2, @computer.ships.length
    assert_equal 2, @computer.ships[0].length
    assert_equal 3, @computer.ships[1].length
  end
end
