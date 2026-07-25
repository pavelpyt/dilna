require "test_helper"

class Payments::PaymentRecorderTest < ActiveSupport::TestCase
  test "zaznamená platbu a označí fakturu za zaplacenou" do
    invoice = invoices(:servis_faktura)

    payment = Payments::PaymentRecorder.new.record_successful_payment(invoice)

    assert payment.succeeded?
    assert_equal invoice.total_with_vat, payment.amount
    assert invoice.reload.paid?
  end
end
