# frozen_string_literal: true

require 'dry/monads'

require './app/repositories/robot_repository'
require './app/models/robot'
require './app/models/table'
require './app/data_stores/env_data_store'

# Controller for handling robot command inputs
class RobotsController
  extend Dry::Monads[:result, :validated, :list, :do]

  MISSING_PARAM_ERROR = 'Must include all 3 placement values, separated by commas (e.g. 2,3,NORTH)'
  PARTIAL_COORDINATE_TYPE_ERROR = 'All coordinates must be integers, but received'
  PLACE_SUCCESS_MESSAGE = 'Robot placed on the board!'
  QUIT_MESSAGE = 'Thanks for playing Toy Robot!'
  NON_EXISTENT_ROBOT_MESSAGE = 'Robot must be placed in order to report its position'

  def self.place(input)
    _parse_place_input(input)
      .then(&method(:_validate_params))
      .fmap(&method(:_convert_to_robot_attributes))
      .fmap { |robot_attrs| ::Robot.new(**robot_attrs, table: ::Table.new) }
      .bind(&:validate)
      .fmap(&::RobotRepository.new(::EnvDataStore.new).method(:place))
      .bind { Success(PLACE_SUCCESS_MESSAGE) }
      .then { |result| _convert_to_output(:place, result) }
  end

  def self.quit
    ::EnvDataStore
      .new
      .delete_all
      .then { Success(QUIT_MESSAGE) }
      .then { |result| _convert_to_output(:quit, result) }
  end

  def self.report
    ::RobotRepository
      .new(::EnvDataStore.new)
      .find
      .fmap(&:report)
      .then(&method(:_convert_to_result))
      .then { |result| _convert_to_output(:report, result) }
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

    def _convert_to_result(maybe_robot)
      maybe_robot
        .to_result
        .or { Failure(List[NON_EXISTENT_ROBOT_MESSAGE]) }
    end

    def _convert_to_robot_attributes(params)
      {
        x_coordinate: params.fetch(:x_coordinate).to_i,
        y_coordinate: params.fetch(:y_coordinate).to_i,
        direction: params.fetch(:direction)
      }
    end

    def _convert_to_output(command, result)
      result.either(
        ->(message) { { result: _success_result(command), message: message } },
        ->(messages) { { result: :failure, message: messages.value.join("\n") } }
      )
    end

    def _success_result(command)
      return :quit if command == :quit

      :success
    end
  end
end
