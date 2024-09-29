module ClientsHelper
  def fetch_active_client
    return nil if session[:active_client_id].empty?
    
    Client.find(session[:active_client_id])
  end
  def minimum_display_severity
    # fetch minimum display severity from session
    if session[:minimum_display_severity].present?
      session[:minimum_display_severity]
    else
      'unknown'
    end
  end
end
