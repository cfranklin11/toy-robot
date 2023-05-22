# frozen_string_literal: true

require 'faker'

require './app/models/table'

# Factory for generating tables for specs
class TableFactory
  def self.valid_attributes
    {
      max_x_coordinate: Faker::Number.between(from: 0, to: 100),
      max_y_coordinate: Faker::Number.between(from: 0, to: 100)
    }
  end

  def self.build(**attributes)
    ::Table.new(**valid_attributes.merge(attributes))
  end
end
