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
        max_y_coordinate: Table::DEFAULT_MAX_COORDINATE,
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

      it "returns a report of the robot's position" do
        expect(report.failure.value).to include(described_class::NON_EXISTENT_ROBOT_MESSAGE)
      end
    end
  end
end
