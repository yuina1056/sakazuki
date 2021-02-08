require "test_helper"

class ElasticsearchControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get elasticsearch_index_url
    assert_response :success
  end
end
