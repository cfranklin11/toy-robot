# frozen_string_literal: true

# Store state of toy robot in env vars
class EnvDataStore
  include Dry::Monads[:maybe, :result]

  STATE_ENV_VAR = '_TOY_ROBOT'

  def find_robot
    ENV
      .fetch(STATE_ENV_VAR, nil)
      .then(&Maybe)
      .fmap { |robot_attributes| JSON.parse(robot_attributes, symbolize_names: true) }
  end

  def insert_robot(robot_attributes)
    ENV[STATE_ENV_VAR] = JSON.dump(robot_attributes)
    Success(nil)
  end
end
