# frozen_string_literal: true

require 'dry/monads'

require './app/data_stores/env_data_store'
require './app/repositories/robot_repository'
require './app/models/robot'
require './app/repositories/table_repository'

# Service for processing robot commands
class RobotService
  extend Dry::Monads[:result, :list]

  PLACE_SUCCESS_MESSAGE = 'Robot placed on the board!'
  MOVE_SUCCESS_MESSAGE = 'Robot moved forward one space!'
  TURN_LEFT_SUCCESS_MESSAGE = 'Robot rotated left!'
  TURN_RIGHT_SUCCESS_MESSAGE = 'Robot rotated right!'
  QUIT_MESSAGE = 'Thanks for playing Toy Robot!'
  NON_EXISTENT_ROBOT_MESSAGE = 'Robot must be placed in order to report its position'
  NON_EXISTENT_TABLE_MESSAGE = 'Could not find a table'
  INVALID_MOVEMENT_MESSAGE = 'Robot is facing the edge of the board and cannot be moved'

  def self.place(params)
    data_store = ::EnvDataStore.new
    repository = ::RobotRepository.new(data_store)

    _find_table(data_store)
      .fmap { |table| _convert_to_robot_attributes(params, table) }
      .fmap(&method(:_build_robot))
      .bind(&:validate)
      .fmap(&repository.method(:save))
      .bind { Success(PLACE_SUCCESS_MESSAGE) }
  end

  def self.quit
    data_store = ::EnvDataStore.new

    data_store
      .delete_all
      .then { Success(QUIT_MESSAGE) }
  end

  def self.report
    data_store = ::EnvDataStore.new
    repository = ::RobotRepository.new(data_store)

    _find_robot(repository)
      .bind { |attributes| _add_table(data_store, attributes) }
      .fmap(&method(:_build_robot))
      .fmap(&:report)
  end

  def self.move
    data_store = ::EnvDataStore.new
    repository = ::RobotRepository.new(data_store)

    _find_robot(repository)
      .bind { |attributes| _add_table(data_store, attributes) }
      .fmap(&method(:_build_robot))
      .fmap(&:move)
      .bind(&:validate)
      .bind(&repository.method(:save))
      .bind { Success(MOVE_SUCCESS_MESSAGE) }
  end

  def self.turn_left
    data_store = ::EnvDataStore.new
    repository = ::RobotRepository.new(data_store)

    _find_robot(repository)
      .bind { |attributes| _add_table(data_store, attributes) }
      .fmap(&method(:_build_robot))
      .fmap(&:turn_left)
      .bind(&:validate)
      .bind(&repository.method(:save))
      .bind { Success(TURN_LEFT_SUCCESS_MESSAGE) }
  end

  def self.turn_right
    data_store = ::EnvDataStore.new
    repository = ::RobotRepository.new(data_store)

    _find_robot(repository)
      .bind { |attributes| _add_table(data_store, attributes) }
      .fmap(&method(:_build_robot))
      .fmap(&:turn_right)
      .bind(&:validate)
      .bind(&repository.method(:save))
      .bind { Success(TURN_RIGHT_SUCCESS_MESSAGE) }
  end

  class << self
    private

    def _find_table(data_store)
      ::TableRepository
        .new(data_store)
        .find
        .to_result
        .or { Failure(Dry::Monads::List[NON_EXISTENT_TABLE_MESSAGE]) }
    end

    def _find_robot(repository)
      repository
        .find
        .to_result
        .or { Failure(Dry::Monads::List[NON_EXISTENT_ROBOT_MESSAGE]) }
    end

    def _add_table(data_store, robot_attributes)
      _find_table(data_store)
        .fmap { |table| robot_attributes.merge(table: table) }
    end

    def _convert_to_robot_attributes(params, table)
      {
        x_coordinate: params.fetch(:x_coordinate).to_i,
        y_coordinate: params.fetch(:y_coordinate).to_i,
        direction: params.fetch(:direction),
        table: table
      }
    end

    def _build_robot(attributes)
      ::Robot.new(**attributes)
    end
  end
end
