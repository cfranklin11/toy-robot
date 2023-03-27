# frozen_string_literal: true

require 'spec_helper'
require './app/controllers/robots_controller'
require './app/repositories/robot_repository'
require './app/data_stores/env_data_store'

describe RobotsController do
  before do
    ENV.delete(EnvDataStore::STATE_ENV_VAR)
  end

  describe '#place' do
    subject(:place) { described_class.new(params).place }

    context 'when a param is missing' do
      let(:params) { "#{Faker::Number.number},#{Faker::Number.number}" }

      it 'is a failure' do
        expect(place).to be_failure
      end

      it 'includes a relevant error message' do
        expect(place.failure.value).to include(described_class::MISSING_PARAM_ERROR)
      end
    end

    context 'when the x_coordinate is not an integer' do
      let(:x_coordinate) { Faker::Number.decimal }
      let(:params) { "#{x_coordinate},#{Faker::Number.number},#{Faker::Compass.cardinal}" }

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
      let(:params) { "#{Faker::Number.number},#{y_coordinate},#{Faker::Compass.cardinal}" }

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
      let(:x_coordinate) { Faker::Number.number }
      let(:y_coordinate) { Faker::Number.number }
      let(:direction) { Faker::Compass.cardinal.upcase }
      let(:params) { "#{x_coordinate},#{y_coordinate},#{direction}" }

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
      let(:x_coordinate) { Faker::Number.number }
      let(:y_coordinate) { Faker::Number.number }
      let(:direction) { Faker::Compass.cardinal.downcase }
      let(:params) { "#{x_coordinate},#{y_coordinate},#{direction}" }

      it 'is a failure' do
        expect(place).to be_failure
      end

      it 'returns a list of error messages' do
        expect(place.failure.value).to match(an_array_containing([be_a(String)]))
      end
    end
  end
end
