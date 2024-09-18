json.extract! data_set, :id, :name, :time_range_start, :time_range_end, :client_id, :description, :created_at, :updated_at
json.url data_set_url(data_set, format: :json)
