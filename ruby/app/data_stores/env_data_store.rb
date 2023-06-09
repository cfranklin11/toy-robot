# frozen_string_literal: true

# Store state of toy robot in env vars
class EnvDataStore
  include Dry::Monads[:maybe, :result, :try]

  STATE_ENV_VAR = '_TOY_ROBOT'

  def find(data_key)
    _fetch_data.bind { |data| Maybe(data[data_key]) }
  end

  def insert(data)
    _fetch_data
      .or { Maybe({}) }
      .fmap { |existing_data| existing_data.merge(**data) }
      .bind(&method(:_save_state))
  end

  def delete(data_key)
    _fetch_data
      .fmap { |data| _delete_data(data_key, data) }
      .fmap(&method(:_save_state))

    Success()
  end

  def delete_all
    ENV.delete(STATE_ENV_VAR)
    Success()
  end

  private

  def _fetch_data
    ENV
      .fetch(STATE_ENV_VAR, nil)
      .then(&method(:_parse_json))
      .to_maybe
  end

  def _parse_json(json)
    Try { JSON.parse(json, symbolize_names: true) }
  end

  def _delete_data(data_key, data)
    data.delete(data_key)
    data
  end

  def _save_state(state)
    ENV[STATE_ENV_VAR] = JSON.dump(state)
    Success()
  end
end
