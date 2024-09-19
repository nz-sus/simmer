# app/controllers/concerns/token_authenticable.rb
module TokenAuthenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_with_token!
  end

  def authenticate_with_token!
    token = request.headers['Authorization']&.split(' ')&.last
    return unauthorized unless token

    service_token = ServiceToken.find_by(token: token)
    if service_token&.valid? && !service_token.expired?
      @current_user = service_token.user
      @service_token = service_token  # Store the token to check permissions later
    else
      unauthorized
    end
  end

  def current_user
    @current_user
  end

  def service_token
    @service_token
  end

  private

  def unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
