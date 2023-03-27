# frozen_string_literal: true

require 'json'
require 'dry/monads'

# Repository for saving and fetching robots
class RobotRepository
  include Dry::Monads[:maybe]

  def initialize(data_store)
    @data_store = data_store
  end

  def find
    @data_store
      .find_robot
      .fmap { |robot_attributes| ::Robot.new(**robot_attributes) }
  end
end
