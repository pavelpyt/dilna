require "test_helper"

class TodayControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:technician)
  end

  test "ukáže dnešní termíny přihlášeného technika" do
    jobs(:baterie).visits.create!(
      user: users(:technician),
      starts_at: Time.current.change(hour: 9),
      ends_at: Time.current.change(hour: 11)
    )

    get today_path

    assert_response :success
    assert_select "body", /Výměna baterie v koupelně/
  end

  test "naskočení a ukončení docházky" do
    assert_difference "TimeEntry.count", 1 do
      post time_entries_path
    end

    running_entry = users(:technician).running_time_entry

    assert_not_nil running_entry

    patch time_entry_path(running_entry)

    assert_not running_entry.reload.running?
  end
end
