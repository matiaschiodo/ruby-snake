require_relative "view/ruby2d"
require_relative "model/state"
require_relative "actions/actions"

class App
  def initialize(app)
    @state = Model::initial_state
  end

  def start
    @view = View::Ruby2dView.new(self)
    timer_thread = Thread.new { init_timer(@view) }
    view.start(@state)
    timer_thread.join
  end

  def init_timer(view)
    loop do
      if @state.game_finish
        puts "Game Finished"
        puts "Score: #{@state.snake.positions.length}"
        break
      end
      @state = Actions::move_snake(@state)
      view.render(@state)
      sleep 0.5
    end
  end

  def send_action(action, params)
    new_state = Actions.send(action, @state, params)
    if new_state.hash != @state.hash
      @state = new_state
    end
    @view.render(@state)
  end
end

app = App.new
app.start