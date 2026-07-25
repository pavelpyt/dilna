require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "nepřihlášeného návštěvníka pošle na přihlášení" do
    get root_path

    assert_redirected_to new_user_session_path
  end

  test "přihlášenému ukáže přehled jeho firmy" do
    sign_in users(:owner)

    get root_path

    assert_response :success
    assert_select "body", /Novák — topení a voda/
  end
end
