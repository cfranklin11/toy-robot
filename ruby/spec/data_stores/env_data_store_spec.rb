# frozen_string_literal: true

require 'dry/monads'

require 'spec_helper'
require './app/data_stores/env_data_store'
require './app/models/robot'

describe EnvDataStore do
  let(:data_store) { EnvDataStore.new }

  before do
    ENV.delete(EnvDataStore::STATE_ENV_VAR)
  end

  after :all do
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
      let(:robot_attributes) { RobotFactory.valid_attributes }

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

  describe '#insert_robot' do
    subject(:insert_robot) { data_store.insert_robot(robot_attributes) }

    let(:robot_attributes) { RobotFactory.valid_attributes }

    it 'is successful' do
      expect(insert_robot).to be_success
    end

    it 'inserts the robot into the data store' do
      insert_robot
      inserted_robot = data_store.find_robot

      expect(inserted_robot.value!).to eq(robot_attributes)
    end
  end

  describe '#delete_robot' do
    subject(:delete_robot) { data_store.delete_robot }

    context 'when a robot exists' do
      let(:robot_state_value) { 'robot' }

      before do
        ENV[EnvDataStore::STATE_ENV_VAR] = robot_state_value
      end

      it 'deletes the robot data' do
        expect { delete_robot }.to change { ENV.fetch(EnvDataStore::STATE_ENV_VAR, nil) }.from(robot_state_value).to(nil)
      end
    end

    context 'when a robot does not exist' do
      it 'does not do anything' do
        expect(ENV.fetch(EnvDataStore::STATE_ENV_VAR, nil)).to be_nil
        expect { delete_robot }.not_to(change { ENV.fetch(EnvDataStore::STATE_ENV_VAR, nil) })
      end
    end
  end
end
