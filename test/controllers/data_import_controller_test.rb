require "test_helper"

class DataImportControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get data_import_create_url
    assert_response :success
  end
end
