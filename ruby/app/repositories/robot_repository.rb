# frozen_string_literal: true

require 'json'
require 'dry/monads'

require './app/repositories/table_repository'

# Repository for saving and fetching robots
class RobotRepository
  include Dry::Monads[:maybe]

  def initialize(data_store)
    @data_store = data_store
  end

  def find
    @data_store
      .find(:robot)
      .bind do |robot_attributes|
        ::TableRepository
          .new(@data_store)
          .find
          .fmap { |table| robot_attributes.merge(table: table) }
      end
      .fmap { |robot_attributes| ::Robot.new(**robot_attributes) }
  end

  def save(robot)
    robot
      .attributes
      .then { |robot_attributes| { robot: robot_attributes } }
      .then(&@data_store.method(:insert))
  end

  def delete
    @data_store.delete(:robot)
  end
end
