# frozen_string_literal: true

require 'spec_helper'
require './app/controllers/robots_controller'

describe RobotsController do
  describe '#place' do
    subject(:place) { described_class.new(params).place }

    context 'when a param is missing' do
      let(:params) { "#{Faker::Number.number},#{Faker::Number.number}" }

      it 'is a failure' do
        expect(place).to be_failure
      end

      it 'includes a relevant error message' do
        expect(place.failure).to eq(described_class::MISSING_PARAM_ERROR)
      end
    end

    context 'when the x_coordinate is not an integer' do
      let(:params) { "#{Faker::Number.decimal},#{Faker::Number.number},#{Faker::Compass.cardinal}" }

      it 'is a failure' do
        expect(place).to be_failure
      end

      it 'includes a relevant error message' do
        expect(place.failure).to include(described_class::PARTIAL_COORDINATE_TYPE_ERROR)
      end
    end

    context 'when the y_coordinate is not an integer' do
      let(:params) { "#{Faker::Number.decimal},#{Faker::Number.number},#{Faker::Compass.cardinal}" }

      it 'is a failure' do
        expect(place).to be_failure
      end

      it 'includes a relevant error message' do
        expect(place.failure).to include(described_class::PARTIAL_COORDINATE_TYPE_ERROR)
      end
    end

    context 'when all params are valid' do
      let(:x_coordinate) { Faker::Number.number }
      let(:y_coordinate) { Faker::Number.number }
      let(:direction) { Faker::Compass.cardinal }
      let(:params) { "#{x_coordinate},#{y_coordinate},#{direction}" }

      it 'is successful' do
        expect(place).to be_success
      end

      it 'places the robot' do
        result = RobotRepository.find

        expect(result[:x_coordinate]).to eq(x_coordinate)
        expect(result[:y_coordinate]).to eq(y_coordinate)
        expect(result[:direction]).to eq(direction)
      end
    end
  end
end
