# frozen_string_literal: true

require 'dry/monads'

require './app/data_stores/env_data_store'
require './app/repositories/robot_repository'
require './app/models/robot'
require './app/models/table'

# Service for processing robot commands
class RobotService
  extend Dry::Monads[:result, :list]

  PLACE_SUCCESS_MESSAGE = 'Robot placed on the board!'
  QUIT_MESSAGE = 'Thanks for playing Toy Robot!'
  NON_EXISTENT_ROBOT_MESSAGE = 'Robot must be placed in order to report its position'

  def self.place(params)
    table = ::Table.new
    data_store = ::EnvDataStore.new
    repository = ::RobotRepository.new(data_store)

    _convert_to_robot_attributes(params)
      .then { |attributes| attributes.merge(table: table) }
      .then(&method(:_build_robot))
      .then(&:validate)
      .fmap(&repository.method(:place))
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

    repository
      .find
      .fmap(&:report)
      .to_result
      .or { Failure(Dry::Monads::List[NON_EXISTENT_ROBOT_MESSAGE]) }
  end

  class << self
    def _convert_to_robot_attributes(params)
      {
        x_coordinate: params.fetch(:x_coordinate).to_i,
        y_coordinate: params.fetch(:y_coordinate).to_i,
        direction: params.fetch(:direction)
      }
    end

    def _build_robot(attributes)
      ::Robot.new(**attributes)
    end
  end
end