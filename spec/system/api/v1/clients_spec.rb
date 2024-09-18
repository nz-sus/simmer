# spec/requests/api/v1/clients_spec.rb
require 'rails_helper'

RSpec.describe 'Clients API', type: :request do
  let(:user) { create(:user) }

  before do
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
      post '/api/v1/clients', params: valid_client_params, headers: headers(user)
      expect(response).to have_http_status(:created)

      created_client = JSON.parse(response.body)
      client_id = created_client['id']
      expect(created_client['name']).to eq('Test Client')
      expect(created_client['description']).to eq('A client for testing purposes')

      # Destroy Client
      delete "/api/v1/clients/#{client_id}", headers: headers(user)
      expect(response).to have_http_status(:no_content)

      # Verify Client is Destroyed
      get "/api/v1/clients/#{client_id}", headers: headers(user)
      expect(response).to have_http_status(:not_found)
    end

    it 'fails to create a client with invalid parameters' do
      # Attempt to Create Client with Invalid Params
      post '/api/v1/clients', params: invalid_client_params, headers: headers(user)
      expect(response).to have_http_status(:unprocessable_entity)

      errors = JSON.parse(response.body)
      expect(errors['name']).to include("can't be blank")
    end
  end

  private

  def headers(user)
    {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
  end
end
