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

  describe '#direction' do
    subject(:direction) { robot.direction }

    let(:robot_params) { base_robot_params }

    it 'matches the direction attribute' do
      expect(direction).to eq(robot_params[:direction])
    end
  end

  describe '#report' do
    subject(:report) { robot.report }

    let(:robot_params) { base_robot_params }
    let(:x_coordinate) { robot_params[:x_coordinate] }
    let(:y_coordinate) { robot_params[:y_coordinate] }
    let(:direction) { robot_params[:direction] }

    it 'returns the position of the robot' do
      expect(report).to eq("#{x_coordinate},#{y_coordinate},#{direction}")
    end
  end

  describe '#move' do
    subject(:move) { robot.move }

    let(:robot_params) { base_robot_params.merge(direction: direction) }
    let(:y_coordinate) { robot_params[:y_coordinate] }
    let(:x_coordinate) { robot_params[:x_coordinate] }

    context 'when the direction is NORTH' do
      let(:direction) { 'NORTH' }

      it 'returns the moved robot' do
        expect(move).to eq(robot)
      end

      it 'moves the robot forward one space' do
        move
        expect(robot.y_coordinate).to eq(y_coordinate + described_class::MOVEMENT_DISTANCE)
      end

      it 'does not move the robot to the side' do
        move
        expect(robot.x_coordinate).to eq(x_coordinate)
      end

      it 'does not rotate the robot' do
        expect(robot.direction).to eq(direction)
      end
    end

    context 'when the direction is SOUTH' do
      let(:direction) { 'SOUTH' }

      it 'returns the moved robot' do
        expect(move).to eq(robot)
      end

      it 'moves the robot forward one space' do
        move
        expect(robot.y_coordinate).to eq(y_coordinate - described_class::MOVEMENT_DISTANCE)
      end

      it 'does not move the robot to the side' do
        move
        expect(robot.x_coordinate).to eq(x_coordinate)
      end

      it 'does not rotate the robot' do
        expect(robot.direction).to eq(direction)
      end
    end

    context 'when the direction is EAST' do
      let(:direction) { 'EAST' }

      it 'returns the moved robot' do
        expect(move).to eq(robot)
      end

      it 'moves the robot forward one space' do
        move
        expect(robot.x_coordinate).to eq(x_coordinate + described_class::MOVEMENT_DISTANCE)
      end

      it 'does not move the robot to the side' do
        move
        expect(robot.y_coordinate).to eq(y_coordinate)
      end

      it 'does not rotate the robot' do
        expect(robot.direction).to eq(direction)
      end
    end

    context 'when the direction is WEST' do
      let(:direction) { 'WEST' }

      it 'returns the moved robot' do
        expect(move).to eq(robot)
      end

      it 'moves the robot forward one space' do
        move
        expect(robot.x_coordinate).to eq(x_coordinate - described_class::MOVEMENT_DISTANCE)
      end

      it 'does not move the robot to the side' do
        move
        expect(robot.y_coordinate).to eq(y_coordinate)
      end

      it 'does not rotate the robot' do
        expect(robot.direction).to eq(direction)
      end
    end
  end

  describe '#turn_left' do
    subject(:turn_left) { robot.turn_left }

    let(:robot_params) { base_robot_params.merge(direction: direction) }

    shared_examples 'a left turn' do
      it 'returns the rotated robot' do
        expect(turn_left).to eq(robot)
      end

      it 'rotates the robot to the left' do
        expect { turn_left }.to change { robot.direction }.from(direction).to(direction_to_left)
      end

      it 'does not move the robot' do
        expect { turn_left }.not_to(change { robot.attributes.slice(:x_coordinate, :y_coordinate) })
      end
    end

    context 'when the direction is NORTH' do
      let(:direction) { 'NORTH' }
      let(:direction_to_left) { 'WEST' }

      it_behaves_like 'a left turn'
    end

    context 'when the direction is SOUTH' do
      let(:direction) { 'SOUTH' }
      let(:direction_to_left) { 'EAST' }

      it_behaves_like 'a left turn'
    end

    context 'when the direction is EAST' do
      let(:direction) { 'EAST' }
      let(:direction_to_left) { 'NORTH' }

      it_behaves_like 'a left turn'
    end

    context 'when the direction is WEST' do
      let(:direction) { 'WEST' }
      let(:direction_to_left) { 'SOUTH' }

      it_behaves_like 'a left turn'
    end
  end
end
