require "test_helper"

class OverdueInvoiceRemindersJobTest < ActiveSupport::TestCase
  test "upomene fakturu po splatnosti e-mailem i SMS" do
    invoices(:servis_faktura).update!(due_on: 9.days.ago.to_date)

    assert_difference "SmsMessage.count", 1 do
      assert_enqueued_emails 1 do
        OverdueInvoiceRemindersJob.perform_now
      end
    end
  end

  test "mimo interval upomínky neposílá" do
    invoices(:servis_faktura).update!(due_on: 1.day.ago.to_date)

    assert_no_difference "SmsMessage.count" do
      OverdueInvoiceRemindersJob.perform_now
    end
  end

  test "zaplacenou fakturu neupomíná" do
    invoices(:servis_faktura).update!(due_on: 9.days.ago.to_date)
    invoices(:servis_faktura).mark_as_paid!

    assert_no_difference "SmsMessage.count" do
      OverdueInvoiceRemindersJob.perform_now
    end
  end
end
