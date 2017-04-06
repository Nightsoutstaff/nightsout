require 'test_helper'

class AdminPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get events_all" do
    get admin_pages_events_all_url
    assert_response :success
  end

  test "should get locals_all" do
    get admin_pages_locals_all_url
    assert_response :success
  end

  test "should get users_all" do
    get admin_pages_users_all_url
    assert_response :success
  end

end
