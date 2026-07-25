require "test_helper"

class ServiceTest < ActiveSupport::TestCase
  test "vyžaduje název" do
    service = accounts(:novak).services.new(unit: "ks")

    assert_not service.valid?
    assert_includes service.errors.attribute_names, :name
  end

  test "nepovolí neznámou jednotku" do
    service = services(:instalaterske_prace)
    service.unit = "kus"

    assert_not service.valid?
    assert_includes service.errors.attribute_names, :unit
  end

  test "nabízí jen nearchivované položky" do
    available_services = accounts(:novak).services.available

    assert_includes available_services, services(:instalaterske_prace)
    assert_not_includes available_services, services(:archivovana)
  end
end
