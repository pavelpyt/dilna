require "test_helper"

class Public::PaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @public_token = jobs(:servis_dokonceny).public_tokens.create!(expires_at: 30.days.from_now)
  end

  test "zákazník zaplatí fakturu z client hubu" do
    assert_difference "Payment.count", 1 do
      post client_hub_payment_path(@public_token.token)
    end

    assert invoices(:servis_faktura).reload.paid?
    assert_equal "paid", jobs(:servis_dokonceny).reload.status
  end

  test "zaplacenou fakturu nejde zaplatit podruhé" do
    invoices(:servis_faktura).mark_as_paid!

    assert_no_difference "Payment.count" do
      post client_hub_payment_path(@public_token.token)
    end

    assert_match(/Není co platit/, flash[:alert])
  end
end
