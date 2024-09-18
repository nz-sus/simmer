json.extract! log_entry, :id, :title, :data_schema, :timestamp, :data_json, :data_set_id, :created_at, :updated_at
json.url log_entry_url(log_entry, format: :json)
