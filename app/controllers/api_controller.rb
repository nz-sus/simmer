class ApiController < ActionController::Base
  #include CableReady::Broadcaster  

  protect_from_forgery with: :exception
  before_action :authenticate_user!
    
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
