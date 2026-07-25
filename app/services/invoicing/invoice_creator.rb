module Invoicing
  # Jediné místo, přes které aplikace vystavuje fakturu. Daňový doklad dělá
  # externí služba (Fakturoid), u sebe držíme jen referenci a zrcadlený stav.
  #
  # Dokud není napojení hotové, běží mock: zaloguje se akce a vrátí se
  # realistická odpověď. Celý tok tak jde projít bez jediného API klíče.
  # Skutečné volání se doplní do create_external_invoice, zbytek aplikace zůstane.
  class InvoiceCreator
    DEFAULT_DUE_IN_DAYS = 14

    def create_invoice_for_job(job)
      external_invoice = create_external_invoice(job)

      job.create_invoice!(
        external_id: external_invoice[:external_id],
        number: external_invoice[:number],
        status: "issued",
        total_with_vat: job.total_with_vat,
        due_on: external_invoice[:due_on],
        pdf_url: external_invoice[:pdf_url]
      )
    end

    private

    def create_external_invoice(job)
      raise NotImplementedError, "Napojení na Fakturoid zatím není hotové." if real_provider_enabled?

      fake_external_invoice(job)
    end

    def real_provider_enabled?
      ENV["FAKTUROID_ENABLED"] == "true"
    end

    def fake_external_invoice(job)
      number = generate_invoice_number(job.account)

      Rails.logger.info(
        "[mock Fakturoid] vystavuji fakturu #{number} pro zakázku #{job.number} " \
        "na #{job.total_with_vat.round} Kč"
      )

      {
        external_id: "fakturoid-mock-#{SecureRandom.hex(6)}",
        number: number,
        due_on: DEFAULT_DUE_IN_DAYS.days.from_now.to_date,
        pdf_url: "https://app.fakturoid.cz/mock/faktury/#{number}.pdf"
      }
    end

    # Čísla faktur jdou po sobě v rámci roku a firmy, stejně jako čísla zakázek.
    def generate_invoice_number(account)
      current_year = Date.current.year
      # Sloupec je potřeba pojmenovat i s tabulkou — zakázky mají number taky.
      highest_number = account.invoices.where("invoices.number LIKE ?", "#{current_year}-%").maximum("invoices.number")
      next_sequence = highest_number ? highest_number.split("-").last.to_i + 1 : 1

      format("%d-%04d", current_year, next_sequence)
    end
  end
end
