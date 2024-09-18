json.extract! incident, :id, :name, :opened_at, :closed_at, :client_id, :created_at, :updated_at
json.url incident_url(incident, format: :json)
