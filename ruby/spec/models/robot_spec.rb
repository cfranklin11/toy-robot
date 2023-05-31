# frozen_string_literal: true

require 'spec_helper'
require './app/models/robot'
require './app/models/table'

describe Robot do
  let(:robot) { described_class.new(**robot_params) }
  let(:table) { Table.new }
  let(:base_robot_params) { RobotFactory.valid_attributes(table).merge(table: table) }

  describe '#validate' do
    subject(:validate) { robot.validate }

    shared_examples 'a validation' do
      it 'that is a Failure' do
        expect(validate).to be_failure
      end

      it 'that contains an error message' do
        expect(validate.failure.value).to include(message)
      end
    end

    context 'when all attributes are valid' do
      let(:robot_params) { base_robot_params }

      it 'is a Success' do
        expect(validate).to be_success
      end

      it 'contains a robot' do
        expect(validate.value!).to be_a(described_class)
      end
    end

    context 'when direction is not a cardinal direction' do
      let(:direction) { Faker::Compass.ordinal }
      let(:robot_params) { base_robot_params.merge(direction: direction) }
      let(:message) { "#{Robot::INVALID_DIRECTION_MESSAGE}, but received '#{direction}'" }

      it_behaves_like 'a validation'
    end

    context 'when direction is not all upper case' do
      let(:direction) { Faker::Compass.cardinal.downcase }
      let(:robot_params) { base_robot_params.merge(direction: direction) }
      let(:message) { "#{Robot::INVALID_DIRECTION_MESSAGE}, but received '#{direction}'" }

      it_behaves_like 'a validation'
    end

    context 'when a coordinate is off the table' do
      let(:x_coordinate) { -1 }
      let(:robot_params) { base_robot_params.merge(x_coordinate: x_coordinate) }
      let(:message) { "The x-coordinate must be greater than or equal to 0, but received '#{x_coordinate}'" }

      it_behaves_like 'a validation'
    end
  end

  describe '#attributes' do
    subject(:attributes) { robot.attributes }

    let(:robot_params) { base_robot_params }

    it 'matches the non-association params passed to the constructor' do
      expect(attributes).to eq(robot_params.except(:table))
    end
  end

  describe '#x_coordinate' do
    subject(:x_coordinate) { robot.x_coordinate }

    let(:robot_params) { base_robot_params }

    it 'matches the x_coordinate attribute' do
      expect(x_coordinate).to eq(robot_params[:x_coordinate])
    end
  end

  describe '#y_coordinate' do
    subject(:y_coordinate) { robot.y_coordinate }

    let(:robot_params) { base_robot_params }

    it 'matches the y_coordinate attribute' do
      expect(y_coordinate).to eq(robot_params[:y_coordinate])
    end
  end
end
