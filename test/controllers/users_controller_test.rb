require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "majitel vidí tým a hodiny" do
    sign_in users(:owner)

    get users_path

    assert_response :success
    assert_select "body", /Tomáš Dvořák/
  end

  test "technik se do správy týmu nedostane" do
    sign_in users(:technician)

    get users_path

    assert_redirected_to root_path
  end

  test "technik nesmí do ceníku" do
    sign_in users(:technician)

    get services_path

    assert_redirected_to root_path
  end

  test "majitel přidá technika" do
    sign_in users(:owner)

    assert_difference "User.count", 1 do
      post users_path, params: {
        user: { first_name: "Nový", last_name: "Technik", email: "novy@novak-topeni.cz",
                role: "staff", password: "heslo1234" }
      }
    end

    assert_redirected_to users_path
  end

  test "majitel nesmí smazat sám sebe" do
    sign_in users(:owner)

    assert_no_difference "User.count" do
      delete user_path(users(:owner))
    end
  end

  test "export hodin vrátí xlsx" do
    sign_in users(:owner)

    get team_hours_export_path

    assert_response :success
    assert_equal "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", response.media_type
  end
end
