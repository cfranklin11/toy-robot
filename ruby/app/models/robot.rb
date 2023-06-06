# frozen_string_literal: true

require 'dry/monads'

# Model that represents the toy robot that moves on the table
class Robot
  include Dry::Monads[:list, :result, :validated]

  attr_reader :x_coordinate, :y_coordinate, :direction

  VALID_DIRECTIONS = %w[NORTH SOUTH EAST WEST].freeze
  INVALID_DIRECTION_MESSAGE = "Direction must be one of #{VALID_DIRECTIONS.join(', ')}".freeze
  MOVEMENT_DISTANCE = 1

  def initialize(x_coordinate:, y_coordinate:, direction:, table:)
    @x_coordinate = x_coordinate
    @y_coordinate = y_coordinate
    @direction = direction
    @table = table
  end

  def validate
    List::Validated[_validate_direction, *_validate_coordinates]
      .traverse
      .to_result
      .bind { Success(self) }
  end

  def attributes
    {
      x_coordinate: x_coordinate,
      y_coordinate: y_coordinate,
      direction: @direction
    }
  end

  def report
    "#{x_coordinate},#{y_coordinate},#{@direction}"
  end

  def move
    _move_forward

    self
  end

  private

  def _validate_direction
    return Valid(nil) if VALID_DIRECTIONS.include? @direction

    Invalid("#{INVALID_DIRECTION_MESSAGE}, but received '#{@direction}'")
  end

  def _validate_coordinates
    @table
      .validate(self)
      .bind { Valid(nil) }
      .or { |errors| errors.map { |error| Invalid(error) } }
  end

  def _move_forward
    case @direction
    when 'NORTH'
      @y_coordinate += MOVEMENT_DISTANCE
    when 'SOUTH'
      @y_coordinate -= MOVEMENT_DISTANCE
    when 'EAST'
      @x_coordinate += MOVEMENT_DISTANCE
    when 'WEST'
      @x_coordinate -= MOVEMENT_DISTANCE
    end
  end
end
