class ServiceTokensController < ApplicationController
  before_action :set_service_token, only: %i[destroy]

  def index
    active_client_id = session[:active_client_id]
    # lookup the client
    @client = active_client_id.blank? ? nil : Client.find(active_client_id)

    @service_tokens = current_user.service_tokens.where(client: @client)
    @new_token = ServiceToken.new # For the creation form
  end

  def create
    # Parse expiration date and permission from form parameters

    expires_at = service_token_params[:expires_at].presence && Time.zone.parse(service_token_params[:expires_at])
    permission = service_token_params[:permission] || 'write_only'

    # Create the service token with the given expiration date and permission
    
    # lookup the client
    client = fetch_active_client
    if client.nil?
      flash[:notice] = 'Choose a client first'
    else
      token = current_user.service_tokens.create!(expires_at:, permission:,
                                                  client:)
      flash[:notice] = "Token created successfully: #{token.token}"
    end
    redirect_to service_tokens_path
  end

  # Destroy an existing service token
  def destroy
    token = current_user.service_tokens.find(params[:id])
    token.destroy
    flash[:notice] = 'Token revoked successfully.'
    redirect_to service_tokens_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_service_token
    @incident = ServiceToken.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def service_token_params
    params.require(:service_token).permit(:expires_at, :permission)
  end
end
