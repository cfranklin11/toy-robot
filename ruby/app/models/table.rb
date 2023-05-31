# frozen_string_literal: true

require 'dry/monads'

# Model that represents the table on which the robot moves
class Table
  include Dry::Monads[:list, :result, :validated, :do]

  attr_reader :max_x_coordinate, :max_y_coordinate

  DEFAULT_MAX_COORDINATE = 5
  MIN_COORDINATE = 0

  def initialize(max_x_coordinate: DEFAULT_MAX_COORDINATE, max_y_coordinate: DEFAULT_MAX_COORDINATE)
    @max_x_coordinate = max_x_coordinate
    @max_y_coordinate = max_y_coordinate
  end

  def validate(robot)
    List::Validated[
      _validate_x_coordinate(robot),
      _validate_y_coordinate(robot)
    ]
      .traverse
      .to_result
      .bind { Success(self) }
  end

  private

  def _validate_x_coordinate(robot)
    return Invalid(_min_validation_message('x-coordinate', robot.x_coordinate)) if robot.x_coordinate < MIN_COORDINATE

    if robot.x_coordinate > @max_x_coordinate
      return Invalid(
        "The x-coordinate must be less than or equal to #{max_x_coordinate}, but received '#{robot.x_coordinate}'"
      )
    end

    Valid(nil)
  end

  def _validate_y_coordinate(robot)
    return Invalid(_min_validation_message('y-coordinate', robot.y_coordinate)) if robot.y_coordinate < MIN_COORDINATE

    if robot.y_coordinate > @max_y_coordinate
      return Invalid(
        "The y-coordinate must be less than or equal to #{max_y_coordinate}, but received '#{robot.y_coordinate}'"
      )
    end

    Valid(nil)
  end

  def _min_validation_message(coordinate_name, coordinate_value)
    "The #{coordinate_name} must be greater than or equal to #{MIN_COORDINATE}, but received '#{coordinate_value}'"
  end
end
