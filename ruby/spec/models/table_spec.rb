# frozen_string_literal: true

require 'dry/monads'

require 'spec_helper'
require './app/models/table'

describe Table do
  let(:table) { described_class.new(**table_params) }
  let(:max_x_coordinate_param) { 4 }
  let(:max_y_coordinate_param) { 6 }
  let(:base_table_params) do
    {
      max_x_coordinate: max_x_coordinate_param,
      max_y_coordinate: max_y_coordinate_param
    }
  end

  shared_examples 'a failed validation' do
    it 'that returns a Failure' do
      expect(validate).to be_failure
    end

    it 'that contains an error message' do
      expect(validate.failure.value).to include(message)
    end
  end

  describe '#validate_robot' do
    subject(:validate_robot) { table.validate_robot(robot) }

    let(:validate) { validate_robot }
    let(:table_params) { base_table_params }
    let(:robot) { RobotFactory.build(**params, table: table) }

    context 'when the robot has a negative x_coordinate' do
      let(:x_coordinate) { Faker::Number.between(from: -100, to: -1) }
      let(:params) do
        { x_coordinate: x_coordinate }
      end
      let(:message) { "The x-coordinate must be greater than or equal to 0, but received '#{x_coordinate}'" }

      it_behaves_like 'a failed validation'
    end

    context 'when the robot has a negative y_coordinate' do
      let(:y_coordinate) { Faker::Number.between(from: -100, to: -1) }
      let(:params) do
        { y_coordinate: y_coordinate }
      end
      let(:message) { "The y-coordinate must be greater than or equal to 0, but received '#{y_coordinate}'" }

      it_behaves_like 'a failed validation'
    end

    context 'when the robot has an x_coordinate that exceeds the maximum' do
      let(:x_coordinate) { Faker::Number.between(from: max_x_coordinate_param + 1, to: max_x_coordinate_param + 100) }
      let(:params) do
        { x_coordinate: x_coordinate }
      end
      let(:message) do
        "The x-coordinate must be less than or equal to #{max_x_coordinate_param}, but received '#{x_coordinate}'"
      end

      it_behaves_like 'a failed validation'
    end

    context 'when the robot has a y_coordinate that exceeds the maximum' do
      let(:y_coordinate) { Faker::Number.between(from: max_y_coordinate_param + 1, to: max_y_coordinate_param + 100) }
      let(:params) do
        { y_coordinate: y_coordinate }
      end
      let(:message) do
        "The y-coordinate must be less than or equal to #{max_y_coordinate_param}, but received '#{y_coordinate}'"
      end

      it_behaves_like 'a failed validation'
    end

    context 'when the robot has an coordinates between 0 and the maximum (inclusive)' do
      let(:params) do
        {
          x_coordinate: Faker::Number.between(from: 0, to: max_x_coordinate_param),
          y_coordinate: Faker::Number.between(from: 0, to: max_y_coordinate_param)
        }
      end

      it 'is a Success' do
        expect(validate_robot).to be_success
      end

      it 'contains a table' do
        expect(validate_robot.value!).to be_a(described_class)
      end
    end
  end

  describe '#validate' do
    subject(:validate) { table.validate }

    context 'when a max coordinate is a string' do
      let(:table_params) { base_table_params.merge(max_x_coordinate: Faker::Number.number.to_s) }
      let(:message) { 'The max x-coordinate must be an integer' }

      it_behaves_like 'a failed validation'
    end

    context 'when a max coordinate is nil' do
      let(:table_params) { base_table_params.merge(max_x_coordinate: nil) }
      let(:message) { 'The max x-coordinate must be an integer' }

      it_behaves_like 'a failed validation'
    end

    context 'when a max coordinate is a float' do
      let(:table_params) { base_table_params.merge(max_x_coordinate: Faker::Number.decimal) }
      let(:message) { 'The max x-coordinate must be an integer' }

      it_behaves_like 'a failed validation'
    end

    context 'when a max coordinate is negative' do
      let(:table_params) { base_table_params.merge(max_x_coordinate: -5) }
      let(:message) { 'The max x-coordinate must not be negative' }

      it_behaves_like 'a failed validation'
    end

    context 'when max coordinates are positive integers' do
      let(:table_params) { base_table_params }

      it 'is a Success' do
        expect(validate).to be_success
      end

      it 'contains a table' do
        expect(validate.value!).to be_a(described_class)
      end
    end

    context 'when max coordinates are zero' do
      let(:table_params) do
        {
          max_x_coordinate: 0,
          max_y_coordinate: 0
        }
      end

      it 'is a Success' do
        expect(validate).to be_success
      end

      it 'contains a table' do
        expect(validate.value!).to be_a(described_class)
      end
    end
  end

  describe '#max_x_coordinate' do
    subject(:max_x_coordinate) { table.max_x_coordinate }

    let(:table_params) { base_table_params }

    it 'equals the max_x_coordinate param' do
      expect(max_x_coordinate).to equal(max_x_coordinate_param)
    end
  end

  describe '#max_y_coordinate' do
    subject(:max_y_coordinate) { table.max_y_coordinate }

    let(:table_params) { base_table_params }

    it 'equals the max_y_coordinate param' do
      expect(max_y_coordinate).to equal(max_y_coordinate_param)
    end
  end

  describe '#attributes' do
    subject(:attributes) { table.attributes }

    let(:table_params) { base_table_params }

    it 'matches the params passed to the constructor' do
      expect(attributes).to eq(table_params)
    end
  end
end
