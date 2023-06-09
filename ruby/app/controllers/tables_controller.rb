# frozen_string_literal: true

require './app/models/table'
require './app/repositories/table_repository'
require './app/data_stores/env_data_store'

# Controller for handling table inputs
class TablesController
  extend Dry::Monads[:result]

  def self.create(max_x_coordinate: Table::DEFAULT_MAX_COORDINATE, max_y_coordinate: Table::DEFAULT_MAX_COORDINATE)
    Table
      .new(max_x_coordinate: max_x_coordinate, max_y_coordinate: max_y_coordinate)
      .validate
      .bind(&TableRepository.new(EnvDataStore.new).method(:save))
      .to_result
      .bind { Success('Table created') }
      .then(&method(:_convert_to_output))
  end

  def self.quit
    TableRepository
      .new(EnvDataStore.new)
      .delete
      .to_result
      .bind { Success('Table removed') }
      .then(&method(:_convert_to_output))
  end

  class << self
    private

    def _convert_to_output(result)
      result.either(
        ->(message) { { result: :success, message: message } },
        ->(messages) { { result: :failure, message: messages.value.join("\n") } }
      )
    end
  end
end
