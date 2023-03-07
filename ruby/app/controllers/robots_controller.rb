# frozen_string_literal: true

require 'dry/monads'

# Controller for handling robot command inputs
class RobotsController
  include Dry::Monads[:result]

  MISSING_PARAM_ERROR = 'Must include all 3 placement values, separated by commas (e.g. 2,3,NORTH)'
  PARTIAL_COORDINATE_TYPE_ERROR = 'All coordinates must be integers, but received'

  def initialize(params)
    @params = params
  end

  def place
    _parse_place_params
      .then(&method(:_validate_param_presence))
      .bind(&method(:_validate_x_coordinate_type))
      .bind(&method(:_validate_y_coordinate_type))
  end

  private

  def _parse_place_params
    x_coordinate, y_coordinate, direction = @params.split(',')
    { x_coordinate: x_coordinate, y_coordinate: y_coordinate, direction: direction }
  end

  def _validate_param_presence(params)
    params.values.any?(nil) ? Failure(MISSING_PARAM_ERROR) : Success(params)
  end

  def _validate_x_coordinate_type(params)
    x_coordinate = params[:x_coordinate]
    _coordinate_type_valid?(x_coordinate) ? Success(params) : Failure(_coordinate_type_error(x_coordinate))
  end

  def _validate_y_coordinate_type(params)
    y_coordinate = params[:y_coordinate]
    _coordinate_type_valid?(y_coordinate) ? Success(params) : Failure(_coordinate_type_error(y_coordinate))
  end

  def _coordinate_type_valid?(coordinate)
    coordinate.to_i.to_s == coordinate
  end

  def _coordinate_type_error(coordinate)
    "#{PARTIAL_COORDINATE_TYPE_ERROR} #{coordinate}"
  end
end
