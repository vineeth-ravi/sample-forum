require 'test_helper'

class LoginControllerTest < ActionDispatch::IntegrationTest
  test "should get get" do
    get login_get_url
    assert_response :success
  end

end
