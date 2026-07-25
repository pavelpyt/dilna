require "test_helper"

class InvoiceTest < ActiveSupport::TestCase
  test "vyžaduje číslo a splatnost" do
    invoice = jobs(:havarie).build_invoice

    assert_not invoice.valid?
    assert_includes invoice.errors.attribute_names, :number
    assert_includes invoice.errors.attribute_names, :due_on
  end

  test "pozná fakturu po splatnosti" do
    invoice = invoices(:servis_faktura)

    assert invoice.overdue?
    assert_equal 10, invoice.days_overdue
  end

  test "zaplacená faktura po splatnosti není" do
    invoice = invoices(:servis_faktura)
    invoice.mark_as_paid!

    assert invoice.paid?
    assert_not invoice.overdue?
    assert_equal 0, invoice.days_overdue
  end

  test "zaplacení posune i zakázku" do
    invoices(:servis_faktura).mark_as_paid!

    assert_equal "paid", jobs(:servis_dokonceny).reload.status
  end
end
