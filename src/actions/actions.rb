module Actions
  def self.move_snake(state)
    next_direction = state.curr_direccion
    next_position = calc_next_position(state)
    if position_is_food?(state, next_position)
      state = grow_snake(state, next_position)
      generate_food(state)
    elsif position_is_valid?(state, next_position)
      move_snake(state, next_position)
    else
      end_game(state)
    end
  end

  def self.change_direction(state, direction)
    if next_direction_is_valid?(state, direction)
      state.curr_direccion = direction
    else
      puts "Invalid direction"
    end
    state
  end

  private

  def generate_food(state)
    new_food = Model::Food.new(rand(state.grid.rows), rand(state.grid.cols))
    state.food = new_food
    state
  end

  def self.position_is_food(state, next_position)
    state.food.row == next_position.row && state.food.col == next_position.col
  end

  def self.grow_snake(state, next_position)
    new_snake = [next_position] + state.snake
    state.snake = new_snake
    state
  end

  def self.calc_next_position(state)
    curr_position = state.snake.positions.first
    case state.curr_direccion
      when Model::Direction::UP
        return Model::Coord.new(
          curr_position.row - 1,
          curr_position.col)
      when Model::Direction::RIGHT
        return Model::Coord.new(
          curr_position.row,
          curr_position.col + 1)
      when Model::Direction::DOWN
        return Model::Coord.new(
          curr_position.row + 1,
          curr_position.col)
      when Model::Direction::LEFT
        return Model::Coord.new(
          curr_position.row,
          curr_position.col - 1)
    end
  end

  def self.position_is_valid?(state, position)
    is_invalid = (position.row < state.grid.rows || position.cols < 0) || (position.col >= state.grid.cols || position.cols < 0)
    return false if is_invalid
    return !(state.snake.positions.include? position)
  end

  def self.move_snake_to(state, next_position)
    new_positions = [next_position] + state.snake.positions[0...-1]
    state.snake.positions = new_positions
    state
  end

  def self.end_game(state)
    state.game_finish = true
    state
  end

  def self.next_direction_is_valid?(state, direction)
    case state.curr_direccion
    when Model::Direction::UP
      return true if direction != Model::Direction::DOWN
    when Model::Direction::RIGHT
      return true if direction != Model::Direction::LEFT
    when Model::Direction::DOWN
      return true if direction != Model::Direction::UP
    when Model::Direction::LEFT
      return true if direction != Model::Direction::RIGHT
    end
    return false
  end
end