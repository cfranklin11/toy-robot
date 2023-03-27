# frozen_string_literal: true

require 'dry/monads'

require 'spec_helper'
require './app/data_stores/env_data_store'

describe EnvDataStore do
  let(:data_store) { EnvDataStore.new }

  before do
    ENV.delete(EnvDataStore::STATE_ENV_VAR)
  end

  describe '#find_robot' do
    subject(:find_robot) { data_store.find_robot }

    context 'when robot attributes do not exist' do

      it 'is None' do
        expect(find_robot).to be_a(Dry::Monads::Maybe::None)
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
        ENV[EnvDataStore::STATE_ENV_VAR] = robot_attributes.to_json
      end

      it 'is Some' do
        expect(find_robot).to be_a(Dry::Monads::Maybe::Some)
      end

      it 'contains robot attributes' do
        expect(find_robot.value!).to eq(robot_attributes)
      end
    end
  end
end
