require "test_helper"

class PwaTest < ActionDispatch::IntegrationTest
  test "manifest je dostupný a má českou identitu appky" do
    get pwa_manifest_path

    assert_response :success
    manifest = response.parsed_body

    assert_equal "Dílna", manifest["name"]
    assert_equal "standalone", manifest["display"]
    assert_equal "#0C6E6B", manifest["theme_color"]
  end

  test "service worker se servíruje jako javascript" do
    get pwa_service_worker_path

    assert_response :success
    assert_match(/javascript/, response.media_type)
  end
end
