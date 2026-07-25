require "test_helper"

class JobItemTest < ActiveSupport::TestCase
  test "vyžaduje popis a kladné množství" do
    job_item = jobs(:havarie).job_items.new(quantity: 0)

    assert_not job_item.valid?
    assert_includes job_item.errors.attribute_names, :description
    assert_includes job_item.errors.attribute_names, :quantity
  end

  test "spočítá celkovou cenu položky" do
    assert_equal 1_625, job_items(:havarie_prace).total_without_vat
  end

  test "převezme údaje z ceníku" do
    job_item = jobs(:havarie).job_items.new
    job_item.copy_from_service(services(:instalaterske_prace))

    assert_equal "Instalatérské práce", job_item.description
    assert_equal "hod", job_item.unit
    assert_equal 650, job_item.unit_price
  end
end
