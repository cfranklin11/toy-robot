# frozen_string_literal: true

require 'spec_helper'
require './app/controllers/robots_controller'
require './app/data_stores/env_data_store'

def convert_attributes_to_params(attributes)
  "#{attributes[:x_coordinate]},#{attributes[:y_coordinate]},#{attributes[:direction]}"
end

describe RobotsController do
  before do
    ENV.delete(EnvDataStore::STATE_ENV_VAR)
  end

  after :all do
    ENV.delete(EnvDataStore::STATE_ENV_VAR)
  end

  shared_examples 'invalid input' do
    it 'returns a failure result' do
      expect(action[:result]).to eq(:failure)
    end

    it 'returns a relevant error message' do
      expect(action[:message]).to match(expected_message)
    end
  end

  shared_examples 'a successful command' do |expected_result|
    it 'with a result' do
      expect(action[:result]).to eq(expected_result)
    end

    it 'with a message' do
      expect(action[:message]).to be_a(String)
      expect(action[:message].length).to be_positive
    end
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
    let(:params) { convert_attributes_to_params(attributes) }
    let(:action) { place }

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
      let(:expected_message) { "#{described_class::PARTIAL_COORDINATE_TYPE_ERROR} '#{x_coordinate}'" }

      it_behaves_like 'invalid input'
    end

    context 'when the y_coordinate is not an integer' do
      let(:y_coordinate) { Faker::Number.decimal }
      let(:attributes) { base_attributes.merge(y_coordinate: y_coordinate) }
      let(:expected_message) { "#{described_class::PARTIAL_COORDINATE_TYPE_ERROR} '#{y_coordinate}'" }

      it_behaves_like 'invalid input'
    end

    context 'when all params are valid' do
      let(:attributes) { base_attributes }

      it_behaves_like 'a successful command', :success
    end
  end

  describe '.quit' do
    subject(:quit) { described_class.quit }

    let(:robot_state_value) { 'robot' }
    let(:action) { quit }

    before do
      ENV[EnvDataStore::STATE_ENV_VAR] = robot_state_value
    end

    it_behaves_like 'a successful command', :quit
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
      let(:action) { report }

      before do
        ENV[EnvDataStore::STATE_ENV_VAR] = robot_state_value
      end

      it_behaves_like 'a successful command', :success
    end

    context 'when the robot has not been placed yet' do
      it 'returns a failure result' do
        expect(report[:result]).to eq(:failure)
      end

      it 'returns a message' do
        expect(report[:message]).to be_a(String)
        expect(report[:message].length).to be_positive
      end
    end
  end
end
