require "application_system_test_case"

# Kalendář je jediná obrazovka, která stojí a padá na JavaScriptu — proto
# jediný systémový test v projektu.
class CalendarTest < ApplicationSystemTestCase
  test "kalendář vykreslí naplánované termíny" do
    sign_in users(:owner)

    visit calendar_path

    assert_selector ".fc-timegrid"
    assert_selector ".fc-visit-title", text: "Havárie — prasklá trubka"
  end
end
