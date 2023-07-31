# frozen_string_literal: true

require 'faker'

require './app/models/robot'
require './app/repositories/robot_repository'
require './app/data_stores/env_data_store'
require_relative './table_factory'

# Factory for generating robots for specs
class RobotFactory
  def self.valid_attributes(table = TableFactory.default)
    {
      x_coordinate: Faker::Number.between(from: 0, to: table.max_x_coordinate),
      y_coordinate: Faker::Number.between(from: 0, to: table.max_y_coordinate),
      direction: Faker::Compass.cardinal.upcase
    }
  end

  def self.build(**attributes)
    table = attributes.fetch(:table, nil) || TableFactory.build
    valid_attributes(table)
      .merge(**attributes, table: table)
      .then { |params| ::Robot.new(**params) }
  end

  def self.create(**attributes)
    table = attributes.fetch(:table, nil) || TableFactory.create
    attributes
      .merge(table: table)
      .then { |robot_attributes| build(**robot_attributes) }
      .tap(&::RobotRepository.new(EnvDataStore.new).method(:save))
  end
end
