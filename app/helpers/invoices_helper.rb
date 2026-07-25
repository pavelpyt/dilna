module InvoicesHelper
  def invoice_status_tag(invoice)
    return render(TagComponent.new(label: "Zaplaceno", tone: :paid)) if invoice.paid?
    return render(TagComponent.new(label: "#{invoice.days_overdue} dní po splatnosti", tone: :over)) if invoice.overdue?

    render TagComponent.new(label: "Vystaveno", tone: :due)
  end
end
