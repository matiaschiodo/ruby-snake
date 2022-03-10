require "minitest/autorun"
require "minitest/mock"
require_relative "../src/actions/actions"
require_relative "../src/model/state"

class ActionTest < MiniTest::Test

  def setup
    @inital_state =
      Model::State.new(
        Model::Snake.new(
          Model::Coord.new(1, 1),
          Model::Coord.new(0, 1)
        ),
        Model::Food.new(4, 4),
        Model::Grid.new(8, 12),
        Direction::DOWN,
        false
    )
  end

  def test_move_snake
    expected_state =
    Model::State.new(
      Model::Snake.new(
        Model::Coord.new(2, 1),
        Model::Coord.new(1, 1)
      ),
      Model::Food.new(4, 4),
      Model::Grid.new(8, 12),
      Direction::DOWN,
      false
    )

    actual_state = Actions::move_snake(@initial_state)
    assert_equal expected_state, actual_state
  end

  def test_change_direction
    expected_state =
    Model::State.new(
      Model::Snake.new(
        Model::Coord.new(2, 1),
        Model::Coord.new(1, 1)
      ),
      Model::Food.new(4, 4),
      Model::Grid.new(8, 12),
      Direction::DOWN,
      false
    )

    actual_state = Actions::change_direction(@initial_state, Model::Direction::UP)
    assert_equal expected_state, actual_state
  end

  def test_snake_grow
    @inital_state =
      Model::State.new(
        Model::Snake.new(
          Model::Coord.new(1, 1),
          Model::Coord.new(0, 1)
        ),
        Model::Food.new(2, 1),
        Model::Grid.new(8, 12),
        Direction::DOWN,
        false
    )

    expected_state =
    Model::State.new(
      Model::Snake.new(
        Model::Coord.new(2, 1),
        Model::Coord.new(1, 1),
        Model::Coord.new(0, 1)
      ),
      Model::Food.new(4, 4),
      Model::Grid.new(8, 12),
      Direction::DOWN,
      false
    )

    actual_state = Actions::move_snake(@initial_state)
    assert_equal [Model::Coord.new(2, 1), Model::Coord.new(1, 1), Model::Coord.new(0, 1)], actual_state.snake.positions
  end

  def test_generate_food
    @inital_state =
      Model::State.new(
        Model::Snake.new(
          Model::Coord.new(1, 1),
          Model::Coord.new(0, 1)
        ),
        Model::Food.new(2, 1),
        Model::Grid.new(8, 12),
        Direction::DOWN,
        false
    )

    expected_state =
      Model::State.new(
        Model::Snake.new(
          Model::Coord.new(2, 1),
          Model::Coord.new(1, 1),
          Model::Coord.new(0, 1)
        ),
        Model::Food.new(0, 0),
        Model::Grid.new(8, 12),
        Direction::DOWN,
        false
    )
    Actions.stub(:rand, 0) do
      actual_state = Actions::move_snake(@initial_state)
      assert_equal expected_state, actual_state
    end
  end
end