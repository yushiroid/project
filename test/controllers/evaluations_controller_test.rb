require 'test_helper'

class EvaluationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get evaluations_new_url
    assert_response :success
  end

end
