require "test_helper"

class FamilyEventsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get family_events_index_url
    assert_response :success
  end
end
