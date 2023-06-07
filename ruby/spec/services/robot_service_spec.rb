# frozen_string_literal: true

require 'spec_helper'

require './app/services/robot_service'

describe RobotService do
  before do
    ENV.delete(EnvDataStore::STATE_ENV_VAR)
  end

  after :all do
    ENV.delete(EnvDataStore::STATE_ENV_VAR)
  end

  describe '.place' do
    subject(:place) { described_class.place(params) }

    let(:table) do
      TableFactory.build(
        max_x_coordinate: Table::DEFAULT_MAX_COORDINATE,
        max_y_coordinate: Table::DEFAULT_MAX_COORDINATE
      )
    end
    let(:base_attributes) { RobotFactory.valid_attributes(table) }

    context 'when all params are valid' do
      let(:params) { base_attributes }

      it 'returns a success result' do
        expect(place).to be_success
      end

      it 'returns a success message' do
        expect(place.value!).to eq(described_class::PLACE_SUCCESS_MESSAGE)
      end

      it 'places the robot' do
        place
        robot = RobotRepository.new(EnvDataStore.new).find

        expect(robot.value!).to be_a(Robot)
      end
    end

    context 'when a Robot param is invalid' do
      let(:invalid_direction) { Faker::Compass.cardinal.downcase }
      let(:params) { base_attributes.merge(direction: invalid_direction) }
      let(:expected_message) { "#{Robot::INVALID_DIRECTION_MESSAGE}, but received '#{invalid_direction}'" }

      it 'is a failure' do
        expect(place).to be_failure
      end

      it 'returns a relevant error message' do
        expect(place.failure.value).to include(expected_message)
      end
    end
  end

  describe '.quit' do
    subject(:quit) { described_class.quit }

    let(:robot_state_value) { 'robot' }

    before do
      ENV[EnvDataStore::STATE_ENV_VAR] = robot_state_value
    end

    it 'is successful' do
      expect(quit).to be_success
    end

    it 'returns a message' do
      expect(quit.value!).to eq(described_class::QUIT_MESSAGE)
    end

    it 'deletes all robot state' do
      expect { quit }.to change { ENV.fetch(EnvDataStore::STATE_ENV_VAR, nil) }.from(robot_state_value).to(nil)
    end
  end

  describe '.report' do
    subject(:report) { described_class.report }

    context 'when the robot has been placed' do
      let(:robot_attributes) { RobotFactory.valid_attributes(TableFactory.default) }
      let(:x_coordinate) { robot_attributes[:x_coordinate] }
      let(:y_coordinate) { robot_attributes[:y_coordinate] }
      let(:direction) { robot_attributes[:direction] }
      let(:robot_state_value) do
        { robot: robot_attributes }.to_json
      end

      before do
        ENV[EnvDataStore::STATE_ENV_VAR] = robot_state_value
      end

      it 'is successful' do
        expect(report).to be_success
      end

      it "returns a report of the robot's position" do
        expect(report.value!).to eq("#{x_coordinate},#{y_coordinate},#{direction}")
      end
    end

    context 'when the robot has not been placed yet' do
      it 'is a failure' do
        expect(report).to be_failure
      end

      it 'returns a message' do
        expect(report.failure.value).to include(described_class::NON_EXISTENT_ROBOT_MESSAGE)
      end
    end
  end

  describe '.move' do
    subject(:move) { described_class.move }

    context 'when the robot has been placed' do
      let(:table) { TableFactory.default }
      let(:y_coordinate) { 0 }
      let(:x_coordinate) { 0 }
      let(:robot_attributes) do
        RobotFactory
          .build(x_coordinate: x_coordinate, y_coordinate: y_coordinate, direction: direction)
          .attributes
      end
      let(:robot_state_value) do
        { robot: robot_attributes }.to_json
      end
      let(:robot_repository) do
        RobotRepository.new(EnvDataStore.new)
      end
      let(:moved_robot) { robot_repository.find.value! }

      before do
        ENV[EnvDataStore::STATE_ENV_VAR] = robot_state_value
      end

      context 'and it is not facing the edge of the table' do
        let(:direction) { 'NORTH' }

        it 'is successful' do
          expect(move).to be_success
        end

        it 'returns a message' do
          expect(move.value!).to eq(described_class::MOVE_SUCCESS_MESSAGE)
        end

        it "saves the robot's movement" do
          move
          expect(moved_robot.y_coordinate).to eq(y_coordinate + 1)
        end
      end

      context 'and it is facing the edge of the table' do
        let(:direction) { 'SOUTH' }

        it 'returns a failure result' do
          expect(move).to be_failure
        end

        it 'returns a message' do
          failures = move.failure.value
          expect(failures.length).to be_positive
          expect(failures).to all(be_a(String))
        end

        it "does not save the robot's movement" do
          expect(moved_robot.attributes).to eq(robot_attributes)
        end
      end
    end

    context 'when the robot has not been placed yet' do
      it 'is a failure' do
        expect(move).to be_failure
      end

      it 'returns a message' do
        expect(move.failure.value).to include(described_class::NON_EXISTENT_ROBOT_MESSAGE)
      end
    end
  end

  describe '.turn_left' do
    subject(:turn_left) { described_class.turn_left }

    context 'when the robot has been placed' do
      let(:direction) { 'NORTH' }
      let(:direction_to_left) { 'WEST' }
      let(:robot_attributes) { RobotFactory.valid_attributes.merge(direction: direction) }
      let(:robot_state_value) do
        { robot: robot_attributes }.to_json
      end
      let(:robot_repository) do
        RobotRepository.new(EnvDataStore.new)
      end
      let(:rotated_robot) { robot_repository.find.value! }

      before do
        ENV[EnvDataStore::STATE_ENV_VAR] = robot_state_value
      end

      it 'is successful' do
        expect(turn_left).to be_success
      end

      it 'returns a message' do
        expect(turn_left.value!).to eq(described_class::TURN_LEFT_SUCCESS_MESSAGE)
      end

      it "saves the robot's rotation" do
        turn_left
        expect(rotated_robot.direction).to eq(direction_to_left)
      end
    end

    context 'when the robot has not been placed yet' do
      it 'is a failure' do
        expect(turn_left).to be_failure
      end

      it 'returns a message' do
        expect(turn_left.failure.value).to include(described_class::NON_EXISTENT_ROBOT_MESSAGE)
      end
    end
  end
end
