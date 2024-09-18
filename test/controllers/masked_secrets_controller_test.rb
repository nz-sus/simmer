require "test_helper"

class MaskedSecretsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get masked_secrets_show_url
    assert_response :success
  end
end
