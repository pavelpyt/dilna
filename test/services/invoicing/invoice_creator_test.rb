require "test_helper"

class Invoicing::InvoiceCreatorTest < ActiveSupport::TestCase
  test "vystaví fakturu na částku zakázky včetně DPH" do
    job = jobs(:havarie)

    invoice = Invoicing::InvoiceCreator.new.create_invoice_for_job(job)

    assert_equal job.total_with_vat, invoice.total_with_vat
    assert_equal "issued", invoice.status
    assert invoice.due_on > Date.current
  end

  test "mock vrátí externí id a odkaz na doklad" do
    invoice = Invoicing::InvoiceCreator.new.create_invoice_for_job(jobs(:havarie))

    assert_match(/\Afakturoid-mock-/, invoice.external_id)
    assert_match(%r{\Ahttps://app\.fakturoid\.cz/}, invoice.pdf_url)
  end

  test "čísluje faktury po sobě v rámci firmy" do
    invoice = Invoicing::InvoiceCreator.new.create_invoice_for_job(jobs(:havarie))

    # Ve fixtures už je faktura 2026-0001.
    assert_equal "#{Date.current.year}-0002", invoice.number
  end
end
