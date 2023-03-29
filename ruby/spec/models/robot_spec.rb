# frozen_string_literal: true

require 'dry/monads'

require 'spec_helper'
require './app/models/robot'

describe Robot do
  let(:robot) { Robot.new(**attributes) }
  let(:base_attributes) { RobotFactory.valid_attributes }

  describe '#validate' do
    subject(:validate) { robot.validate }

    context 'when all attributes are valid' do
      let(:attributes) { base_attributes }

      it 'is a Success' do
        expect(validate).to be_a(Dry::Monads::Result::Success)
      end

      it 'contains a robot' do
        expect(validate.value!).to be_a(Robot)
      end
    end

    context 'when direction is not a cardinal direction' do
      let(:direction) { Faker::Compass.ordinal }
      let(:attributes) { base_attributes.merge(direction: direction) }

      it 'is a Failure' do
        expect(validate).to be_a(Dry::Monads::Result::Failure)
      end

      it 'contains the invalid direction error message' do
        expect(validate.failure.value).to include("#{Robot::INVALID_DIRECTION_MESSAGE}, but received #{direction}")
      end
    end

    context 'when direction is not all upper case' do
      let(:direction) { Faker::Compass.cardinal.downcase }
      let(:attributes) { base_attributes.merge(direction: direction) }

      it 'is a Failure' do
        expect(validate).to be_a(Dry::Monads::Result::Failure)
      end

      it 'contains the invalid direction error message' do
        expect(validate.failure.value).to include("#{Robot::INVALID_DIRECTION_MESSAGE}, but received #{direction}")
      end
    end
  end

  describe '#attributes' do
    subject(:robot_attributes) { robot.attributes }

    let(:attributes) { base_attributes }

    it 'matches the attributes passed to the constructor' do
      expect(robot_attributes).to eq(attributes)
    end
  end
end
