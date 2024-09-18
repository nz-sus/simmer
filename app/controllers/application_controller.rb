class ApplicationController < ActionController::Base
  include ClientsHelper
  include CableReady::Broadcaster
  layout :determine_layout

  protect_from_forgery with: :exception
  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  def determine_layout
    return false if turbo_frame_request?
    if current_user
      "application"
    else
      "public"
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :password_confirmation, :current_password])
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
  
  private

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
