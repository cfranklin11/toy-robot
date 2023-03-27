# frozen_string_literal: true

require 'dry/monads'

require 'spec_helper'
require './app/repositories/robot_repository'
require './app/data_stores/env_data_store'
require './app/models/robot'

describe RobotRepository do
  let(:data_store) { EnvDataStore.new }
  let(:repository) { described_class.new(data_store) }

  before do
    ENV.delete(EnvDataStore::STATE_ENV_VAR)
  end

  describe '#find' do
    subject(:find) { repository.find }

    context 'when robot attributes do not exist' do
      before do
        allow(data_store).to receive(:find_robot).and_return(Dry::Monads::Maybe::None.new)
      end

      it 'is None' do
        expect(find).to be_a(Dry::Monads::Maybe::None)
      end
    end

    context 'when robot attributes exist in the environment' do
      let(:robot_attributes) do
        {
          x_coordinate: Faker::Number.number,
          y_coordinate: Faker::Number.number,
          direction: Faker::Compass.cardinal
        }
      end

      before do
        allow(data_store).to receive(:find_robot).and_return(Dry::Monads::Maybe::Some.new(robot_attributes))
      end

      it 'is Some' do
        expect(find).to be_a(Dry::Monads::Maybe::Some)
      end

      it 'contains a robot' do
        expect(find.value!).to be_a(Robot)
      end
    end
  end
end
