module ClientsHelper
  def active_client
    # fetch active client from session
    if session[:active_client_id].present?
      Client.find(session[:active_client_id])
    else
      nil
    end
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
