# frozen_string_literal: true

require 'spec_helper'
require './app/controllers/robots_controller'
require './app/repositories/robot_repository'
require './app/data_stores/env_data_store'
require './app/models/robot'

def convert_attributes_to_params(attributes)
  "#{attributes[:x_coordinate]},#{attributes[:y_coordinate]},#{attributes[:direction]}"
end

shared_examples 'invalid input' do
  it 'returns a failure result' do
    expect(place[:result]).to eq(:failure)
  end

  it 'returns a relevant error message' do
    expect(place[:message]).to match(expected_message)
  end
end

describe RobotsController do
  before do
    ENV.delete(EnvDataStore::STATE_ENV_VAR)
  end

  after :all do
    ENV.delete(EnvDataStore::STATE_ENV_VAR)
  end

  describe '#place' do
    subject(:place) { described_class.new(params).place }

    let(:base_attributes) { RobotFactory.valid_attributes }
    let(:params) { convert_attributes_to_params(attributes) }

    context 'when a param is missing' do
      let(:attributes) do
        base_attributes.delete(:direction)
        base_attributes
      end
      let(:expected_message) { described_class::MISSING_PARAM_ERROR }

      it_behaves_like 'invalid input'
    end

    context 'when the x_coordinate is not an integer' do
      let(:x_coordinate) { Faker::Number.decimal }
      let(:attributes) { base_attributes.merge(x_coordinate: x_coordinate) }
      let(:expected_message) { "#{described_class::PARTIAL_COORDINATE_TYPE_ERROR} #{x_coordinate}" }

      it_behaves_like 'invalid input'
    end

    context 'when the y_coordinate is not an integer' do
      let(:y_coordinate) { Faker::Number.decimal }
      let(:attributes) { base_attributes.merge(y_coordinate: y_coordinate) }
      let(:expected_message) { "#{described_class::PARTIAL_COORDINATE_TYPE_ERROR} #{y_coordinate}" }

      it_behaves_like 'invalid input'
    end

    context 'when all params are valid' do
      let(:attributes) { base_attributes }

      it 'returns a success result' do
        expect(place[:result]).to eq(:success)
      end

      it 'returns a success message' do
        expect(place[:message]).to eq(described_class::PLACE_SUCCESS_MESSAGE)
      end

      it 'places the robot' do
        place
        robot = RobotRepository.new(EnvDataStore.new).find

        expect(robot.value!).to be_a(Robot)
      end
    end

    context 'when a Robot param is invalid' do
      let(:invalid_direction) { Faker::Compass.cardinal.downcase }
      let(:attributes) { base_attributes.merge(direction: invalid_direction) }
      let(:expected_message) { "#{Robot::INVALID_DIRECTION_MESSAGE}, but received #{invalid_direction}" }

      it_behaves_like 'invalid input'
    end
  end

  describe '#quit' do
    subject(:quit) { described_class.new('').quit }

    let(:robot_state_value) { 'robot' }

    before do
      ENV[EnvDataStore::STATE_ENV_VAR] = robot_state_value
    end

    it 'returns a quit result' do
      expect(quit[:result]).to eq(:quit)
    end

    it 'returns a message' do
      expect(quit[:message]).to eq(described_class::QUIT_MESSAGE)
    end

    it 'deletes all robot state' do
      expect { quit }.to change { ENV.fetch(EnvDataStore::STATE_ENV_VAR, nil) }.from(robot_state_value).to(nil)
    end
  end
end
