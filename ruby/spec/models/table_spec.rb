# frozen_string_literal: true

require 'dry/monads'

require 'spec_helper'
require './app/models/table'

describe Table do
  let(:table) { described_class.new(**table_params) }
  let(:max_x_coordinate_param) { 4 }
  let(:max_y_coordinate_param) { 6 }
  let(:table_params) do
    {
      max_x_coordinate: max_x_coordinate_param,
      max_y_coordinate: max_y_coordinate_param
    }
  end

  describe '#validate' do
    subject(:validate) { table.validate(robot) }

    let(:robot) { RobotFactory.build(**params, table: table) }

    shared_examples 'a validation' do
      it 'that is a Failure' do
        expect(validate).to be_failure
      end

      it 'that contains an error message' do
        expect(validate.failure.value).to include(message)
      end
    end

    context 'when the robot has a negative x_coordinate' do
      let(:x_coordinate) { Faker::Number.between(from: -100, to: -1) }
      let(:params) do
        { x_coordinate: x_coordinate }
      end
      let(:message) { "The x-coordinate must be greater than or equal to 0, but received #{x_coordinate}" }

      it_behaves_like 'a validation'
    end

    context 'when the robot has a negative y_coordinate' do
      let(:y_coordinate) { Faker::Number.between(from: -100, to: -1) }
      let(:params) do
        { y_coordinate: y_coordinate }
      end
      let(:message) { "The y-coordinate must be greater than or equal to 0, but received #{y_coordinate}" }

      it_behaves_like 'a validation'
    end

    context 'when the robot has an x_coordinate that exceeds the maximum' do
      let(:x_coordinate) { Faker::Number.between(from: max_x_coordinate_param + 1, to: max_x_coordinate_param + 100) }
      let(:params) do
        { x_coordinate: x_coordinate }
      end
      let(:message) do
        "The x-coordinate must be less than or equal to #{max_x_coordinate_param}, but received #{x_coordinate}"
      end

      it_behaves_like 'a validation'
    end

    context 'when the robot has a y_coordinate that exceeds the maximum' do
      let(:y_coordinate) { Faker::Number.between(from: max_y_coordinate_param + 1, to: max_y_coordinate_param + 100) }
      let(:params) do
        { y_coordinate: y_coordinate }
      end
      let(:message) do
        "The y-coordinate must be less than or equal to #{max_y_coordinate_param}, but received #{y_coordinate}"
      end

      it_behaves_like 'a validation'
    end

    context 'when the robot has an coordinates between 0 and the maximum (inclusive)' do
      let(:params) do
        {
          x_coordinate: Faker::Number.between(from: 0, to: max_x_coordinate_param),
          y_coordinate: Faker::Number.between(from: 0, to: max_y_coordinate_param)
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

    it 'equals the max_x_coordinate param' do
      expect(max_x_coordinate).to equal(max_x_coordinate_param)
    end
  end

  describe '#max_y_coordinate' do
    subject(:max_y_coordinate) { table.max_y_coordinate }

    it 'equals the max_y_coordinate param' do
      expect(max_y_coordinate).to equal(max_y_coordinate_param)
    end
  end
end
