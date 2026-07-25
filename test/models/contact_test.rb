require "test_helper"

class ContactTest < ActiveSupport::TestCase
  test "vyžaduje jméno a příjmení" do
    contact = clients(:u_kotvy).contacts.new

    assert_not contact.valid?
    assert_includes contact.errors.attribute_names, :first_name
    assert_includes contact.errors.attribute_names, :last_name
  end

  test "poskládá celé jméno a iniciály" do
    assert_equal "Martin Kolář", contacts(:kolar).full_name
    assert_equal "MK", contacts(:kolar).initials
  end
end
