require "test_helper"

class QuoteTest < ActiveSupport::TestCase
  test "nepovolí neznámý stav" do
    quote = quotes(:baterie_nabidka)
    quote.status = "nevim"

    assert_not quote.valid?
    assert_includes quote.errors.attribute_names, :status
  end

  test "čeká na zákazníka, dokud platí" do
    assert quotes(:baterie_nabidka).waiting_for_customer?
  end

  test "po platnosti už na zákazníka nečeká" do
    quote = quotes(:baterie_nabidka)
    quote.update!(valid_until: 1.day.ago.to_date)

    assert quote.expired?
    assert_not quote.waiting_for_customer?
  end

  test "schválení posune i zakázku" do
    quote = quotes(:baterie_nabidka)
    quote.approve_by_customer!

    assert quote.approved?
    assert_equal "approved", quote.job.reload.status
  end

  test "zamítnutí posune zakázku do zamítnuto" do
    quote = quotes(:baterie_nabidka)
    quote.reject_by_customer!

    assert quote.rejected?
    assert_equal "rejected", quote.job.reload.status
  end

  test "bere položky a součty ze zakázky" do
    quote = quotes(:baterie_nabidka)

    assert_equal quote.job.total_with_vat, quote.total_with_vat
  end
end
