require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "vyžaduje jméno i příjmení" do
    user = User.new(account: accounts(:novak), email: "nekdo@novak-topeni.cz", password: "heslo1234")

    assert_not user.valid?
    assert_includes user.errors.attribute_names, :first_name
    assert_includes user.errors.attribute_names, :last_name
  end

  test "nepovolí neznámou roli" do
    user = users(:owner)
    user.role = "dispatcher"

    assert_not user.valid?
    assert_includes user.errors.attribute_names, :role
  end

  test "poskládá celé jméno a iniciály" do
    assert_equal "Petr Novák", users(:owner).full_name
    assert_equal "PN", users(:owner).initials
  end

  test "rozliší majitele od technika" do
    assert users(:owner).owner?
    assert_not users(:owner).staff?
    assert users(:technician).staff?
  end
end
