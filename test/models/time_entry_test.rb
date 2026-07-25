require "test_helper"

class TimeEntryTest < ActiveSupport::TestCase
  test "vyžaduje začátek" do
    time_entry = users(:owner).time_entries.new

    assert_not time_entry.valid?
    assert_includes time_entry.errors.attribute_names, :started_at
  end

  test "konec musí být po začátku" do
    time_entry = users(:owner).time_entries.new(started_at: Time.current, ended_at: 1.hour.ago)

    assert_not time_entry.valid?
    assert_includes time_entry.errors.attribute_names, :ended_at
  end

  test "nepovolí druhou rozdělanou docházku" do
    users(:owner).time_entries.create!(started_at: 10.minutes.ago)
    second_entry = users(:owner).time_entries.new(started_at: Time.current)

    assert_not second_entry.valid?
    assert_includes second_entry.errors.full_messages.to_sentence, "rozdělanou"
  end

  test "spočítá odpracované hodiny" do
    assert_equal 2.0, time_entries(:owner_dnes).duration_in_hours
  end

  test "ukončení docházky zapíše konec" do
    time_entry = users(:technician).time_entries.create!(started_at: 30.minutes.ago)
    time_entry.stop!

    assert_not time_entry.running?
  end

  test "sečte hodiny za období" do
    assert_equal 2.0, users(:owner).hours_worked_between(Date.current.beginning_of_week, Date.current.end_of_week.end_of_day)
  end
end
