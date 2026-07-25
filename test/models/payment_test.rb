require "test_helper"

class PaymentTest < ActiveSupport::TestCase
  test "nepovolí neznámý stav" do
    payment = invoices(:servis_faktura).payments.new(amount: 100, status: "nevim")

    assert_not payment.valid?
    assert_includes payment.errors.attribute_names, :status
  end
end
