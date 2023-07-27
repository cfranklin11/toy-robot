# frozen_string_literal: true

require 'faker'

require './app/models/table'
require './app/repositories/table_repository'
require './app/data_stores/env_data_store'

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

  def self.create(**attributes)
    ::TableRepository
      .new(::EnvDataStore.new)
      .tap { |repo| repo.save(build(**attributes)) }
      .find
      .value!
  end

  def self.default
    ::Table.new
  end
end
