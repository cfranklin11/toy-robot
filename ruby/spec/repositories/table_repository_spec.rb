# frozen_string_literal: true

require 'dry/monads'

require 'spec_helper'
require './app/repositories/table_repository'
require './app/data_stores/env_data_store'
require './app/models/table'

describe TableRepository do
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

    context 'when table attributes do not exist' do
      before do
        allow(data_store).to receive(:find).and_return(Dry::Monads::Maybe::None.new)
      end

      it 'is None' do
        expect(find).to be_a(Dry::Monads::Maybe::None)
      end
    end

    context 'when table attributes exist in the environment' do
      let(:table_attributes) { TableFactory.valid_attributes }

      before do
        allow(data_store).to receive(:find).and_return(Dry::Monads::Maybe::Some.new(table_attributes))
      end

      it 'is Some' do
        expect(find).to be_a(Dry::Monads::Maybe::Some)
      end

      it 'contains a table' do
        expect(find.value!).to be_a(Table)
      end
    end
  end

  describe '#save' do
    subject(:save) { repository.save(table) }

    let(:table) { TableFactory.build }

    it 'saves the table' do
      save
      saved_table = TableRepository.new(EnvDataStore.new).find

      expect(saved_table.value!).to be_a(Table)
    end
  end

  describe '#delete' do
    subject(:delete) { repository.delete }

    let(:table) { TableFactory.build }

    before do
      repository.save(table)
    end

    it 'deletes the table' do
      expect { delete }.to(
        change { repository.find }.from(be_a(Dry::Monads::Maybe::Some)).to(Dry::Monads::Maybe::None)
      )
    end
  end
end
