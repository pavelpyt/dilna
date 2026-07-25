module Payments
  # Odkaz na zaplacení kartou. V ostrém provozu ho vyrobí Stripe,
  # v MVP se jen zaloguje a vrátí se odkaz zpátky do client hubu.
  class PaymentLinkCreator
    def create_payment_link_for_invoice(invoice)
      raise NotImplementedError, "Napojení na Stripe zatím není hotové." if real_provider_enabled?

      Rails.logger.info(
        "[mock Stripe] připravuji platební odkaz na fakturu #{invoice.number} " \
        "na #{invoice.total_with_vat.round} Kč"
      )

      payment_url = "https://checkout.stripe.com/mock/#{SecureRandom.hex(8)}"
      invoice.update!(payment_url: payment_url)

      payment_url
    end

    private

    def real_provider_enabled?
      ENV["STRIPE_ENABLED"] == "true"
    end
  end
end
