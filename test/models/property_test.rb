require "test_helper"

class PropertyTest < ActiveSupport::TestCase
  test "vyžaduje ulici a město" do
    property = clients(:u_kotvy).properties.new

    assert_not property.valid?
    assert_includes property.errors.attribute_names, :street
    assert_includes property.errors.attribute_names, :city
  end

  test "poskládá celou adresu" do
    assert_equal "Bělehradská 45, 120 00 Praha 2", properties(:u_kotvy_provozovna).full_address
  end

  test "bez označení použije jako popisek adresu" do
    property = properties(:u_kotvy_provozovna)
    property.label = nil

    assert_equal property.full_address, property.display_label
  end
end
