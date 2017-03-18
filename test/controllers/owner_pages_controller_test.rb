require 'test_helper'

class OwnerPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get publish_events" do
    get owner_pages_publish_events_url
    assert_response :success
  end

  test "should get publish_locals" do
    get owner_pages_publish_locals_url
    assert_response :success
  end

end
