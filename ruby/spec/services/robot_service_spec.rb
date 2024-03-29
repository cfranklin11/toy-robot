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

    let(:base_attributes) { RobotFactory.valid_attributes(table) }

    context 'when all params are valid' do
      let(:params) { base_attributes }

      context 'when a table already exists' do
        let(:table) { TableFactory.create }
        let(:repository) { RobotRepository.new(EnvDataStore.new) }

        it 'returns a success result' do
          expect(place).to be_success
        end

        it 'returns a success message' do
          expect(place.value!).to eq(described_class::PLACE_SUCCESS_MESSAGE)
        end

        it 'places the robot' do
          expect { place }.to(
            change { repository.find }.from(Dry::Monads::None).to(be_a(Dry::Monads::Some))
          )
        end
      end

      context 'when a table does not exist yet' do
        let(:table) { TableFactory.build }
        let(:expected_message) { described_class::NON_EXISTENT_TABLE_MESSAGE }

        it 'is a failure' do
          expect(place).to be_failure
        end

        it 'returns a relevant error message' do
          expect(place.failure.value).to include(expected_message)
        end
      end
    end

    context 'when a Robot param is invalid' do
      let(:invalid_direction) { Faker::Compass.cardinal.downcase }
      let(:params) { base_attributes.merge(direction: invalid_direction) }
      let(:expected_message) { "#{Robot::INVALID_DIRECTION_MESSAGE}, but received '#{invalid_direction}'" }

      let!(:table) { TableFactory.create }

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

    let(:game_state_value) { 'robot' }

    before do
      ENV[EnvDataStore::STATE_ENV_VAR] = game_state_value
    end

    it 'is successful' do
      expect(quit).to be_success
    end

    it 'returns a message' do
      expect(quit.value!).to eq(described_class::QUIT_MESSAGE)
    end

    it 'deletes all robot state' do
      expect { quit }.to change { ENV.fetch(EnvDataStore::STATE_ENV_VAR, nil) }.from(game_state_value).to(nil)
    end
  end

  describe '.report' do
    subject(:report) { described_class.report }

    context 'when the robot has been placed' do
      let!(:robot) { RobotFactory.create }
      let(:x_coordinate) { robot.x_coordinate }
      let(:y_coordinate) { robot.y_coordinate }
      let(:direction) { robot.direction }

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
      let(:y_coordinate) { 0 }
      let(:x_coordinate) { 0 }
      let(:robot_repository) do
        RobotRepository.new(EnvDataStore.new)
      end
      let(:moved_robot) { robot_repository.find.value! }
      let(:table) { TableFactory.create(**TableFactory.default.attributes) }

      let!(:robot) do
        RobotFactory.create(
          x_coordinate: x_coordinate,
          y_coordinate: y_coordinate,
          direction: direction,
          table: table
        )
      end
      let(:robot_attributes) { robot.attributes }

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
          expect(moved_robot.fetch(:y_coordinate)).to eq(y_coordinate + 1)
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
          expect(moved_robot).to eq(robot_attributes)
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
      let(:robot_repository) { RobotRepository.new(EnvDataStore.new) }
      let(:rotated_robot) { robot_repository.find.value! }

      before do
        RobotFactory.create(direction: direction)
      end

      it 'is successful' do
        expect(turn_left).to be_success
      end

      it 'returns a message' do
        expect(turn_left.value!).to eq(described_class::TURN_LEFT_SUCCESS_MESSAGE)
      end

      it "saves the robot's rotation" do
        turn_left
        expect(rotated_robot.fetch(:direction)).to eq(direction_to_left)
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

  describe '.turn_right' do
    subject(:turn_right) { described_class.turn_right }

    context 'when the robot has been placed' do
      let(:direction) { 'NORTH' }
      let(:direction_to_right) { 'EAST' }
      let(:robot_repository) { RobotRepository.new(EnvDataStore.new) }
      let(:rotated_robot) { robot_repository.find.value! }

      before do
        RobotFactory.create(direction: direction)
      end

      it 'is successful' do
        expect(turn_right).to be_success
      end

      it 'returns a message' do
        expect(turn_right.value!).to eq(described_class::TURN_RIGHT_SUCCESS_MESSAGE)
      end

      it "saves the robot's rotation" do
        turn_right
        expect(rotated_robot.fetch(:direction)).to eq(direction_to_right)
      end
    end

    context 'when the robot has not been placed yet' do
      it 'is a failure' do
        expect(turn_right).to be_failure
      end

      it 'returns a message' do
        expect(turn_right.failure.value).to include(described_class::NON_EXISTENT_ROBOT_MESSAGE)
      end
    end
  end
end
