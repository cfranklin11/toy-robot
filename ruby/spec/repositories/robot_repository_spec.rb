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

    let(:table) { TableFactory.create }

    context 'when robot attributes do not exist' do
      it 'is None' do
        expect(find).to be_a(Dry::Monads::Maybe::None)
      end
    end

    context 'when robot attributes exist in the environment' do
      before do
        RobotFactory.create(table: table)
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

    let(:table) { TableFactory.create }
    let(:robot) { RobotFactory.build(table: table) }

    it 'saves the robot' do
      expect { save }.to(
        change { repository.find }.from(Dry::Monads::Maybe::None).to(be_a(Dry::Monads::Maybe::Some))
      )
    end
  end

  describe '#delete' do
    subject(:delete) { repository.delete }

    before do
      RobotFactory.create
    end

    it 'deletes the robot' do
      expect { delete }.to(
        change { repository.find }.from(be_a(Dry::Monads::Maybe::Some)).to(Dry::Monads::Maybe::None)
      )
    end
  end
end
