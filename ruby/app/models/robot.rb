# frozen_string_literal: true

require 'dry/monads'

# Model that represents the toy robot that moves on the board
class Robot
  include Dry::Monads[:list, :result, :validated, :do]

  VALID_DIRECTIONS = %w[NORTH SOUTH EAST WEST].freeze
  INVALID_DIRECTION_MESSAGE = "Direction must be one of #{VALID_DIRECTIONS.join(', ')}".freeze

  def initialize(x_coordinate:, y_coordinate:, direction:)
    @x_coordinate = x_coordinate
    @y_coordinate = y_coordinate
    @direction = direction
  end

  def validate
    yield List::Validated[
      _validate_direction
    ].traverse.to_result

    Success(self)
  end

  private

  def _validate_direction
    return Valid(nil) if VALID_DIRECTIONS.include? @direction

    Invalid("#{INVALID_DIRECTION_MESSAGE}, but received #{@direction}")
  end
end
