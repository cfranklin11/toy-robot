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

  after :all do
    ENV.delete(EnvDataStore::STATE_ENV_VAR)
  end

  describe '#find' do
    subject(:find) { repository.find }

    context 'when robot attributes do not exist' do
      before do
        allow(data_store).to receive(:find).and_return(Dry::Monads::Maybe::None.new)
      end

      it 'is None' do
        expect(find).to be_a(Dry::Monads::Maybe::None)
      end
    end

    context 'when robot attributes exist in the environment' do
      let(:robot_attributes) { RobotFactory.valid_attributes }

      before do
        allow(data_store).to receive(:find).and_return(Dry::Monads::Maybe::Some.new(robot_attributes))
      end

      it 'is Some' do
        expect(find).to be_a(Dry::Monads::Maybe::Some)
      end

      it 'contains a robot' do
        expect(find.value!).to be_a(Robot)
      end
    end
  end

  describe '#save' do
    subject(:save) { repository.save(robot) }

    let(:robot) { RobotFactory.build }

    it 'saves the robot' do
      save
      saved_robot = RobotRepository.new(EnvDataStore.new).find

      expect(saved_robot.value!).to be_a(Robot)
    end
  end

  describe '#delete' do
    subject(:delete) { repository.delete }

    let(:robot) { RobotFactory.build }

    before do
      repository.save(robot)
    end

    it 'deletes the robot' do
      expect { delete }.to(
        change { repository.find }.from(be_a(Dry::Monads::Maybe::Some)).to(Dry::Monads::Maybe::None)
      )
    end
  end
end
