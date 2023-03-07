# frozen_string_literal: true

require 'dry/monads'

# Controller for handling robot command inputs
class RobotsController
  include Dry::Monads[:result, :validated, :list, :do]

  MISSING_PARAM_ERROR = 'Must include all 3 placement values, separated by commas (e.g. 2,3,NORTH)'
  PARTIAL_COORDINATE_TYPE_ERROR = 'All coordinates must be integers, but received'

  def initialize(params)
    @params = params
  end

  def place
    yield List::Validated[
      _validate_param_presence,
      _validate_x_coordinate_type,
      _validate_y_coordinate_type
    ].traverse.to_result
  end

  private

  def _place_params
    x_coordinate, y_coordinate, direction = @params.split(',')
    { x_coordinate: x_coordinate, y_coordinate: y_coordinate, direction: direction }
  end

  def _validate_param_presence
    _place_params.values.any?(nil) ? Invalid(MISSING_PARAM_ERROR) : Valid(nil)
  end

  def _validate_x_coordinate_type
    x_coordinate = _place_params[:x_coordinate]
    _coordinate_type_valid?(x_coordinate) ? Valid(nil) : Invalid(_coordinate_type_error(x_coordinate))
  end

  def _validate_y_coordinate_type
    y_coordinate = _place_params[:y_coordinate]
    _coordinate_type_valid?(y_coordinate) ? Valid(nil) : Invalid(_coordinate_type_error(y_coordinate))
  end

  def _coordinate_type_valid?(coordinate)
    coordinate.to_i.to_s == coordinate
  end

  def _coordinate_type_error(coordinate)
    "#{PARTIAL_COORDINATE_TYPE_ERROR} #{coordinate}"
  end
end
