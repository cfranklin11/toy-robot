# frozen_string_literal: true

require 'json'
require 'dry/monads'

# Repository for saving and fetching tables
class TableRepository
  include Dry::Monads[:maybe]

  def initialize(data_store)
    @data_store = data_store
  end

  def find
    @data_store
      .find(:table)
      .fmap { |table_attributes| ::Table.new(**table_attributes) }
  end

  def save(table)
    table
      .attributes
      .then { |table_attributes| { table: table_attributes } }
      .then(&@data_store.method(:insert))
  end

  def delete
    @data_store.delete(:table)
  end
end
