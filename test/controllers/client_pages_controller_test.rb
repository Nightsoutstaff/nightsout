require 'test_helper'

class ClientPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get all_events" do
    get client_pages_all_events_url
    assert_response :success
  end

  test "should get following" do
    get client_pages_following_url
    assert_response :success
  end

  test "should get event_page" do
    get client_pages_event_page_url
    assert_response :success
  end

  test "should get local_page" do
    get client_pages_local_page_url
    assert_response :success
  end

end
