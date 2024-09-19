class ApiController < ActionController::Base
  #include CableReady::Broadcaster  
  skip_before_action :verify_authenticity_token

  #before_action :authenticate_user!
  # replaced by
  include TokenAuthenticable
  before_action :skip_csrf_for_token_auth

  def skip_csrf_for_token_auth
    unless @service_token.present?      
      protect_from_forgery with: :exception
    end
  end
    
  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      Rails.logger.error("Could not access record #{exception}")
      redirect_to "/"
    else
      redirect_to "/401"
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    if current_user
      Rails.logger.error("Could not find record #{exception}")
      redirect_to "/403"
    else
      redirect_to "/401"
    end
  end
  
end
