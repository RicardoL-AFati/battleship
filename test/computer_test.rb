require './test/test_helper'
require 'o_stream_catcher'
require './lib/game'
require './lib/computer'
require './lib/board'

class ComputerTest < Minitest::Test
  def setup
    @board = Board.new
    @computer = Computer.new(@board)
    @valid_positions = ["A1", "A2", "A3", "A4", "B1", "B2", "B3", "B4", "C1", "C2", "C3", "C4", "D1", "D2", "D3", "D4"]
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

  def test_it_calls_down_first_to_place_smart_shot
    @computer.successful_shot = "A3"
    mocked_down = Minitest::Mock.new

    mocked_down.expect(:call, "B3", [@valid_positions.reject {|coordinate| coordinate == "A3"}])

    @computer.stub :down, mocked_down do
      @computer.place_smart_shot(@valid_positions.reject {|coordinate| coordinate == "A3"})
    end

    mocked_down.verify
  end

  def test_it_calls_right_second_to_place_smart_shot
    @computer.successful_shot = "A3"

    mocked_down = Minitest::Mock.new
    mocked_right = MiniTest::Mock.new

    invalid_coordinates = ["A3", "B3"]
    valid_coordinates = @valid_positions.reject do |coordinate|
      invalid_coordinates.include?(coordinate)
    end

    mocked_down.expect(:call, false, [valid_coordinates])
    mocked_right.expect(:call, "A4", [valid_coordinates])

    @computer.stub :down, mocked_down do
      @computer.stub :right, mocked_right do
        @computer.place_smart_shot(valid_coordinates)
      end
    end

    mocked_down.verify
    mocked_right.verify
  end

  def test_it_calls_up_third_to_place_smart_shot
    @computer.successful_shot = "B3"

    mocked_down = Minitest::Mock.new
    mocked_right = MiniTest::Mock.new
    mocked_up = MiniTest::Mock.new

    invalid_coordinates = ["B3", "C3", "B4"]
    valid_coordinates = @valid_positions.reject do |coordinate|
      invalid_coordinates.include?(coordinate)
    end

    mocked_down.expect(:call, false, [valid_coordinates])
    mocked_right.expect(:call, false, [valid_coordinates])
    mocked_up.expect(:call, "A3", [valid_coordinates])

    @computer.stub :down, mocked_down do
      @computer.stub :right, mocked_right do
        @computer.stub :up, mocked_up do
          @computer.place_smart_shot(valid_coordinates)
        end
      end
    end

    mocked_down.verify
    mocked_right.verify
    mocked_up.verify
  end


  def test_it_calls_left_fourth_to_place_smart_shot_down
    @computer.successful_shot = "A3"

    mocked_down = Minitest::Mock.new
    mocked_right = MiniTest::Mock.new
    mocked_up = MiniTest::Mock.new
    mocked_left = MiniTest::Mock.new

    invalid_coordinates = ["A3", "B3", "A4"]
    valid_coordinates = @valid_positions.reject do |coordinate|
      invalid_coordinates.include?(coordinate)
    end

    mocked_down.expect(:call, false, [valid_coordinates])
    mocked_right.expect(:call, false, [valid_coordinates])
    mocked_up.expect(:call, false, [valid_coordinates])
    mocked_left.expect(:call, "A2", [valid_coordinates])

    @computer.stub :down, mocked_down do
      @computer.stub :right, mocked_right do
        @computer.stub :up, mocked_up do
          @computer.stub :left, mocked_left do
            @computer.place_smart_shot(valid_coordinates)
          end
        end
      end
    end

    mocked_down.verify
    mocked_right.verify
    mocked_up.verify
    mocked_left.verify
  end

  def test_it_returns_smart_shot_down
    @computer.successful_shot = "A3"


    valid_coordinates = @valid_positions.reject do |coordinate|
      coordinate == "A3"
    end

    assert_equal "B3", @computer.place_smart_shot(valid_coordinates)
  end

  def test_it_returns_smart_shot_right_after_invalid
    @computer.successful_shot = "A3"

    invalid_coordinates = ["A3", "B3"]
    valid_coordinates = @valid_positions.reject do |coordinate|
      invalid_coordinates.include?(coordinate)
    end

    assert_equal "A4", @computer.place_smart_shot(valid_coordinates)
  end

  def test_it_returns_smart_shot_right_due_to_board_constraints
    @computer.successful_shot = "D3"

    valid_coordinates = @valid_positions.reject do |coordinate|
      coordinate == "D3"
    end

    assert_equal "D4", @computer.place_smart_shot(valid_coordinates)
  end

  def test_it_returns_smart_shot_up_after_invalid
    @computer.successful_shot = "B3"

    invalid_coordinates = ["C3", "B4"]
    valid_coordinates = @valid_positions.reject do |coordinate|
      invalid_coordinates.include?(coordinate)
    end

    assert_equal "A3", @computer.place_smart_shot(valid_coordinates)
  end

  def test_it_returns_smart_shot_up_due_to_board_constraints
    @computer.successful_shot = "D4"

    valid_coordinates = @valid_positions.reject do |coordinate|
      coordinate == "D4"
    end

    assert_equal "C4", @computer.place_smart_shot(valid_coordinates)
  end


  def test_it_returns_smart_shot_left_after_invalid
    @computer.successful_shot = "B3"

    invalid_coordinates = ["C3", "B4", "A3"]
    valid_coordinates = @valid_positions.reject do |coordinate|
      invalid_coordinates.include?(coordinate)
    end

    assert_equal "B2", @computer.place_smart_shot(valid_coordinates)
  end

  def test_it_returns_smart_shot_left_due_to_board_constraints_and_invalid
    @computer.successful_shot = "A4"

    invalid_coordinates = ["A4", "B4"]
    valid_coordinates = @valid_positions.reject do |coordinate|
      invalid_coordinates.include?(coordinate)
    end

    assert_equal "A3", @computer.place_smart_shot(valid_coordinates)
  end
end
