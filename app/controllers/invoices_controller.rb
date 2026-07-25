class InvoicesController < ApplicationController
  def index
    authorize Invoice
    @invoices = current_account.invoices.includes(job: :client).newest_first
    @unpaid_total = current_account.invoices.unpaid.sum(:total_with_vat)
  end

  # Vystavení faktury z dokončené zakázky.
  def create
    authorize Invoice
    job = current_account.jobs.find(params[:job_id])

    if job.invoice.present?
      redirect_to job, alert: "Zakázka už fakturu má."
      return
    end

    unless job.can_change_status_to?("invoiced")
      redirect_to job, alert: "Fakturu jde vystavit až z dokončené zakázky."
      return
    end

    Invoicing::InvoiceCreator.new.create_invoice_for_job(job)
    job.change_status_to!("invoiced")

    Payments::PaymentLinkCreator.new.create_payment_link_for_invoice(job.invoice)

    redirect_to job, notice: "Faktura byla vystavena."
  end
end
