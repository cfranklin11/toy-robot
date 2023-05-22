# frozen_string_literal: true

require 'dry/monads'

require './app/repositories/robot_repository'
require './app/models/robot'
require './app/data_stores/env_data_store'

# Controller for handling robot command inputs
class RobotsController
  include Dry::Monads[:result, :validated, :list, :do]

  MISSING_PARAM_ERROR = 'Must include all 3 placement values, separated by commas (e.g. 2,3,NORTH)'
  PARTIAL_COORDINATE_TYPE_ERROR = 'All coordinates must be integers, but received'
  PLACE_SUCCESS_MESSAGE = 'Robot placed on the board!'
  QUIT_MESSAGE = 'Thanks for playing Toy Robot!'

  def initialize(params)
    @params = params
  end

  def place
    _place_params
      .then(&method(:_validate_params))
      .fmap(&method(:_convert_to_robot_attributes))
      .fmap { |robot_attrs| ::Robot.new(**robot_attrs, table: ::Table.new) }
      .bind(&:validate)
      .fmap(&::RobotRepository.new(::EnvDataStore.new).method(:place))
      .then { |result| _convert_to_result(:place, result) }
  end

  def quit
    ::EnvDataStore
      .new
      .delete_all
      .then { _convert_to_result(:quit, Success()) }
  end

  private

  def _place_params
    x_coordinate, y_coordinate, direction = @params.split(',')
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
    "#{PARTIAL_COORDINATE_TYPE_ERROR} #{coordinate}"
  end

  def _convert_to_robot_attributes(params)
    {
      x_coordinate: params.fetch(:x_coordinate).to_i,
      y_coordinate: params.fetch(:y_coordinate).to_i,
      direction: params.fetch(:direction)
    }
  end

  def _convert_to_result(command, result)
    result.either(
      ->(_) { { result: _success_result(command), message: _success_message(command) } },
      ->(messages) { { result: :failure, message: messages.value.join('\n') } }
    )
  end

  def _success_message(command)
    case command
    when :place
      PLACE_SUCCESS_MESSAGE
    when :quit
      QUIT_MESSAGE
    else
      ''
    end
  end

  def _success_result(command)
    return :quit if command == :quit

    :success
  end
end
