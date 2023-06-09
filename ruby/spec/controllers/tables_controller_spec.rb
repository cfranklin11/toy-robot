# frozen_string_literal: true

require 'spec_helper'
require './app/controllers/tables_controller'
require './app/repositories/table_repository'
require './app/data_stores/env_data_store'
require './app/models/table'

describe TablesController do
  before do
    ENV.delete(EnvDataStore::STATE_ENV_VAR)
  end

  after :all do
    ENV.delete(EnvDataStore::STATE_ENV_VAR)
  end

  shared_examples 'invalid input' do
    it 'returns a failure result' do
      expect(action[:result]).to eq(:failure)
    end

    it 'returns a relevant error message' do
      expect(action[:message]).to match(expected_message)
    end
  end

  shared_examples 'a successful command' do
    it 'with a result' do
      expect(action[:result]).to eq(:success)
    end

    it 'with a message' do
      expect(action[:message]).to be_a(String)
      expect(action[:message].length).to be_positive
    end
  end

  describe '.create' do
    subject(:create) { described_class.create(**params) }

    let(:action) { create }
    let(:base_params) do
      {
        max_x_coordinate: Faker::Number.number,
        max_y_coordinate: Faker::Number.number
      }
    end
    let(:table_repository) { TableRepository.new(EnvDataStore.new) }

    context 'when creation is successful' do
      let(:params) { base_params }

      it 'saves a table in the data store' do
        create
        expect(table_repository.find.value!).to be_a(Table)
      end

      it_behaves_like 'a successful command'
    end

    context 'when the table is invalid' do
      let(:params) { base_params.merge(max_x_coordinate: -5) }
      let(:expected_message) { 'The max x-coordinate must not be negative' }

      it 'does not save a table in the data store' do
        create
        expect(table_repository.find).to be_none
      end

      it_behaves_like 'invalid input'
    end
  end

  describe '.quit' do
    subject(:quit) { described_class.quit }

    let(:table_repository) { TableRepository.new(EnvDataStore.new) }
    let(:table_state_value) { 'table' }
    let(:action) { quit }

    before do
      ENV[EnvDataStore::STATE_ENV_VAR] = table_state_value
    end

    it 'deletes the table in the data store' do
      quit
      expect(table_repository.find).to be_none
    end

    it_behaves_like 'a successful command'
  end
end
