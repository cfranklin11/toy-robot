# frozen_string_literal: true

require 'faker'

require './app/models/robot'

# Factory for generating robots for specs
class RobotFactory
  def self.valid_attributes
    {
      x_coordinate: Faker::Number.number,
      y_coordinate: Faker::Number.number,
      direction: Faker::Compass.cardinal.upcase
    }
  end

  def self.build(**attributes)
    ::Robot.new(**valid_attributes.merge(attributes))
  end
end
