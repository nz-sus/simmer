# spec/support/request_spec_helper.rb
module RequestSpecHelper
  def authenticated_header(user)
    token = user.create_new_auth_token
    {
      'Authorization': "Bearer #{token}",
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    }
  end
end
