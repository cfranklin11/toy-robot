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

  describe '#find' do
    subject(:find) { data_store.find(data_key) }

    let(:data_key) { :robot }

    context 'when the data does not exist' do
      it 'is None' do
        expect(find).to be_a(Dry::Monads::Maybe::None)
      end
    end

    context 'when the data exists in the environment' do
      context 'and is valid JSON' do
        let(:robot_attributes) { RobotFactory.valid_attributes }

        before do
          ENV[EnvDataStore::STATE_ENV_VAR] = { env_data_key => robot_attributes }.to_json
        end

        context 'and the data includes the given key' do
          let(:env_data_key) { data_key }

          it 'is Some' do
            expect(find).to be_a(Dry::Monads::Maybe::Some)
          end

          it 'contains the data' do
            expect(find.value!).to eq(robot_attributes)
          end
        end

        context 'but the data does not include the given key' do
          let(:env_data_key) { :not_the_data_key }

          it 'is None' do
            expect(find).to be_a(Dry::Monads::Maybe::None)
          end
        end
      end

      context 'but is invalid JSON' do
        before do
          ENV[EnvDataStore::STATE_ENV_VAR] = 'loddy doddy doddy'
        end

        it 'is None' do
          expect(find).to be_a(Dry::Monads::Maybe::None)
        end
      end
    end
  end

  describe '#insert' do
    subject(:insert) { data_store.insert({ data_key => data }) }

    let(:data) do
      { muh: 'dataz' }
    end
    let(:data_key) { :data }

    shared_examples 'a data write' do
      it 'that is successful' do
        expect(insert).to be_success
      end

      it 'that inserts the data' do
        insert
        inserted_data = data_store.find(data_key)

        expect(inserted_data.value!).to eq(data)
      end
    end

    context 'when no data exists' do
      it_behaves_like 'a data write'
    end

    context 'when data with the same key already exists' do
      before do
        ENV[EnvDataStore::STATE_ENV_VAR] = { data_key => { totally: 'different' } }.to_json
      end

      it_behaves_like 'a data write'
    end
  end

  describe '#delete' do
    subject(:delete) { data_store.delete(:robot) }

    context 'when a robot exists' do
      let(:robot_state) do
        { robot: 'robot' }.to_json
      end

      before do
        ENV[EnvDataStore::STATE_ENV_VAR] = robot_state
      end

      it 'is successful' do
        expect(delete).to be_success
      end

      it 'deletes the robot data' do
        expect { delete }.to(
          change { ENV.fetch(EnvDataStore::STATE_ENV_VAR, nil) }.from(robot_state).to({}.to_json)
        )
      end
    end

    context 'when a robot does not exist' do
      it 'is successful' do
        expect(delete).to be_success
      end

      it 'does not do anything' do
        expect(ENV.fetch(EnvDataStore::STATE_ENV_VAR, nil)).to be_nil
        expect { delete }.not_to(change { ENV.fetch(EnvDataStore::STATE_ENV_VAR, nil) })
      end
    end
  end

  describe '#delete_all' do
    subject(:delete_all) { data_store.delete_all }

    let(:state) do
      { muh: 'dataz' }.to_json
    end

    before do
      ENV[EnvDataStore::STATE_ENV_VAR] = state
    end

    it 'is successful' do
      expect(delete_all).to be_success
    end

    it 'deletes all data' do
      expect { delete_all }.to(change { ENV.fetch(EnvDataStore::STATE_ENV_VAR, nil) }.from(state).to(nil))
    end
  end
end
