# spec/system/api/v1/client_api_spec.rb
require 'rails_helper'

RSpec.describe 'Client API', type: :request do
  before do
    driven_by(:rack_test)
    # Create a User and Authenticate
    user = create(:user)
    sign_in user
  end

  let(:valid_client_params) do
    { client: { name: 'Test Client', description: 'A client for testing purposes' } }
  end

  let(:invalid_client_params) do
    { client: { name: '', description: '' } }
  end

  describe 'Create and Destroy Client' do
    it 'creates and destroys a client successfully' do
      # Create Client
      post '/api/internal/clients', params: valid_client_params
      expect(response).to have_http_status(:created)

      created_client = JSON.parse(response.body)
      client_id = created_client['id']
      expect(created_client['name']).to eq('Test Client')
      expect(created_client['description']).to eq('A client for testing purposes')

      # Destroy Client
      delete "/api/internal/clients/#{client_id}"
      expect(response).to have_http_status(:no_content)

      # Verify Client is Destroyed
      get "/api/internal/clients/#{client_id}"
      expect(response).to have_http_status(:not_found)
    end

    it 'fails to create a client with invalid parameters' do
      # Attempt to Create Client with Invalid Params
      post '/api/internal/clients', params: invalid_client_params
      expect(response).to have_http_status(:unprocessable_entity)

      errors = JSON.parse(response.body)
      expect(errors).to include("Name can't be blank")
    end
  end
end
