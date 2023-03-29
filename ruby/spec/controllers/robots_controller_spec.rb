# frozen_string_literal: true

require 'spec_helper'
require './app/controllers/robots_controller'
require './app/repositories/robot_repository'
require './app/data_stores/env_data_store'

def convert_attributes_to_params(attributes)
  "#{attributes[:x_coordinate]},#{attributes[:y_coordinate]},#{attributes[:direction]}"
end

describe RobotsController do
  before do
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

      it 'is a failure' do
        expect(place).to be_failure
      end

      it 'includes a relevant error message' do
        expect(place.failure.value).to include(described_class::MISSING_PARAM_ERROR)
      end
    end

    context 'when the x_coordinate is not an integer' do
      let(:x_coordinate) { Faker::Number.decimal }
      let(:attributes) { base_attributes.merge(x_coordinate: x_coordinate) }

      it 'is a failure' do
        expect(place).to be_failure
      end

      it 'includes a relevant error message' do
        expect(place.failure.value).to include(
          "#{described_class::PARTIAL_COORDINATE_TYPE_ERROR} #{x_coordinate}"
        )
      end
    end

    context 'when the y_coordinate is not an integer' do
      let(:y_coordinate) { Faker::Number.decimal }
      let(:attributes) { base_attributes.merge(y_coordinate: y_coordinate) }

      it 'is a failure' do
        expect(place).to be_failure
      end

      it 'includes a relevant error message' do
        expect(place.failure.value).to include(
          "#{described_class::PARTIAL_COORDINATE_TYPE_ERROR} #{y_coordinate}"
        )
      end
    end

    context 'when all params are valid' do
      let(:attributes) { base_attributes }

      it 'is successful' do
        expect(place).to be_success
      end

      it 'places the robot' do
        place
        robot = RobotRepository.new(EnvDataStore.new).find

        expect(robot.value!).to be_a(Robot)
      end
    end

    context 'when a param is invalid' do
      let(:attributes) { base_attributes.merge(direction: Faker::Compass.cardinal.downcase) }

      it 'is a failure' do
        expect(place).to be_failure
      end

      it 'returns a list of error messages' do
        expect(place.failure.value).to match(an_array_matching([be_a(String)]))
      end
    end
  end
end
