module Payments
  # Zaznamená zaplacení faktury. V ostrém provozu sem přijde webhook
  # payment_intent.succeeded ze Stripu; v MVP to spouští tlačítko v client hubu.
  class PaymentRecorder
    def record_successful_payment(invoice)
      Rails.logger.info("[mock Stripe] přijata platba faktury #{invoice.number}")

      ActiveRecord::Base.transaction do
        payment = invoice.payments.create!(
          external_id: "stripe-mock-#{SecureRandom.hex(6)}",
          amount: invoice.total_with_vat,
          status: "succeeded",
          paid_at: Time.current
        )

        invoice.mark_as_paid!
        payment
      end
    end
  end
end
