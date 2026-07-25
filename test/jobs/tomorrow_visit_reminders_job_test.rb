require "test_helper"

class TomorrowVisitRemindersJobTest < ActiveSupport::TestCase
  test "připomene zítřejší termín" do
    jobs(:havarie).visits.create!(
      user: users(:technician),
      starts_at: Date.tomorrow.beginning_of_day.change(hour: 9),
      ends_at: Date.tomorrow.beginning_of_day.change(hour: 11)
    )

    assert_difference "SmsMessage.count", 1 do
      TomorrowVisitRemindersJob.perform_now
    end
  end

  test "bez zítřejších termínů neposílá nic" do
    assert_no_difference "SmsMessage.count" do
      TomorrowVisitRemindersJob.perform_now
    end
  end
end
