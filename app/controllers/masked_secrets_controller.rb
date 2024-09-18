class MaskedSecretsController < ApplicationController  
  before_action :set_client, only: %i[ export index ]
  before_action :set_masked_secret, only: %i[ show update ]
  # nested under a client path
  def show      
    # include all gitleaks_results that reference this masked_secret
    @gitleaks_results = @masked_secret.gitleaks_results
  end

  def update
    if @masked_secret.update(masked_secret_params) do |format|
        format.turbo_stream
        format.html { redirect_to client_masked_secret_path(@masked_secret.client, @masked_secret) }
      end
    else
      render :show, status: :unprocessable_entity  
    end

  end

  def index
    @minimum_display_severity = session[:minimum_display_severity] || 'UNKNOWN'
    # fetch all masked secrets for the client sorted by count and above the active severity
    @masked_secrets = @client.masked_secrets.above_severity(@minimum_display_severity).by_severity_then_count    
    @for_export = false
  end

  def export 
    index
    @for_export = true # After index, set for_export to true for the export view
    render template: 'masked_secrets/index', layout: 'export'
  end

  private

  def set_client
    @client = Client.find(params[:client_id])
    raise ActiveRecord::RecordNotFound unless @client
  end

  def set_masked_secret
    set_client    
    @masked_secret = MaskedSecret.find_by!(id: params[:id], client: @client)
  end

  def masked_secret_params
    params.require(:masked_secret).permit(:severity)
  end
end
