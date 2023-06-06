# frozen_string_literal: true

require 'dry/monads'

require './app/services/robot_service'

# Controller for handling robot command inputs
class RobotsController
  extend Dry::Monads[:result, :validated, :list, :do]

  MISSING_PARAM_ERROR = 'Must include all 3 placement values, separated by commas (e.g. 2,3,NORTH)'
  PARTIAL_COORDINATE_TYPE_ERROR = 'All coordinates must be integers, but received'

  def self.place(input)
    _parse_place_input(input)
      .then(&method(:_validate_params))
      .bind(&::RobotService.method(:place))
      .then { |result| _convert_to_output(:success, result) }
  end

  def self.quit
    RobotService
      .quit
      .then { |result| _convert_to_output(:quit, result) }
  end

  def self.report
    RobotService
      .report
      .then { |result| _convert_to_output(:success, result) }
  end

  class << self
    def _parse_place_input(input)
      x_coordinate, y_coordinate, direction = input.split(',')
      { x_coordinate: x_coordinate, y_coordinate: y_coordinate, direction: direction }
    end

    def _validate_params(params)
      yield List::Validated[
        _validate_param_presence(params),
        _validate_x_coordinate_type(params),
        _validate_y_coordinate_type(params)
      ].traverse.to_result

      Success(params)
    end

    def _validate_param_presence(params)
      params.values.any?(nil) ? Invalid(MISSING_PARAM_ERROR) : Valid(nil)
    end

    def _validate_x_coordinate_type(params)
      x_coordinate = params[:x_coordinate]
      _coordinate_type_valid?(x_coordinate) ? Valid(nil) : Invalid(_coordinate_type_error(x_coordinate))
    end

    def _validate_y_coordinate_type(params)
      y_coordinate = params[:y_coordinate]
      _coordinate_type_valid?(y_coordinate) ? Valid(nil) : Invalid(_coordinate_type_error(y_coordinate))
    end

    def _coordinate_type_valid?(coordinate)
      coordinate.to_i.to_s == coordinate
    end

    def _coordinate_type_error(coordinate)
      "#{PARTIAL_COORDINATE_TYPE_ERROR} '#{coordinate}'"
    end

    def _convert_to_output(success_result, result)
      result.either(
        ->(message) { { result: success_result, message: message } },
        ->(messages) { { result: :failure, message: messages.value.join("\n") } }
      )
    end
  end
end
