class ClientMailer < ApplicationMailer
  def quote_ready(quote)
    @quote = quote
    @job = quote.job
    @client_hub_url = client_hub_url(@job.public_token_for_client_hub.token)

    mail to: @job.client.email, subject: "Nabídka na #{@job.title}"
  end

  def invoice_issued(invoice)
    @invoice = invoice
    @job = invoice.job
    @client_hub_url = client_hub_url(@job.public_token_for_client_hub.token)

    mail to: @job.client.email, subject: "Faktura #{@invoice.number}"
  end

  def overdue_invoice_reminder(invoice)
    @invoice = invoice
    @job = invoice.job
    @client_hub_url = client_hub_url(@job.public_token_for_client_hub.token)

    mail to: @job.client.email, subject: "Připomenutí faktury #{@invoice.number}"
  end
end
