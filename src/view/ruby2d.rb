require "ruby2d"
require_relative "../model/state"

module View
  class Ruby2dView
    def initialize
      @pixel_size = 50
      @app = app
    end


    def start(state)
      extend Ruby2d::DSL
      set(
        title: "Snake",
        width: @pixel_size * state.grid.cols,
        height: @pixel_size * state.grid.rows)
      on :key_down do |event|
        handle_key_event(event)
      end
    end

    def render(state)
      extend Ruby2d::DSL
      close if state.game_finish
      render_food(state)
      render_snake(state)
    end

    private
    def render_food
      @food.remove if @food
      extend Ruby2d::DSL
      @food = state.food
      Square.new(
        x: food.col * @pixel_size,
        y: food.row * @pixel_size,
        size: @pixel_size,
        color: 'yellow'
      )
    end

    def render_snake
      @snake_positions.each(&:remove) if @snake_positions
      extend Ruby2d::DSL
      snake = state.snake
      @snake_positions = snake.positions.map do |pos|
        Square.new(
          x: pos.col * @pixel_size,
          y: pos.row * @pixel_size,
          size: @pixel_size,
          color: 'green'
        )
      end
    end

    def handle_key_event(event)
      case event.key
      when "up"
        @app.send_action(:change_direction, Model::Direction::UP)
      when "down"
        @app.send_action(:change_direction, Model::Direction::DOWN)
      when "right"
        @app.send_action(:change_direction, Model::Direction::RIGHT)
      when "left"
        @app.send_action(:change_direction, Model::Direction::LEFT)
      end
    end
  end
end