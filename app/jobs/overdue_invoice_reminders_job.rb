# Denní upomínka faktur po splatnosti. Spouští ji Solid Queue podle
# config/recurring.yml, ne uživatel.
class OverdueInvoiceRemindersJob < ApplicationJob
  queue_as :default

  # Upomíná se jednou za tři dny, ať se zákazník neutopí v e-mailech.
  REMINDER_INTERVAL_IN_DAYS = 3

  def perform
    overdue_invoices.each do |invoice|
      next unless reminder_due_for?(invoice)

      send_reminder_for(invoice)
    end
  end

  private

  def overdue_invoices
    Invoice.unpaid.where(due_on: ..Date.yesterday).includes(job: :client)
  end

  def reminder_due_for?(invoice)
    days_overdue = invoice.days_overdue

    days_overdue.positive? && (days_overdue % REMINDER_INTERVAL_IN_DAYS).zero?
  end

  def send_reminder_for(invoice)
    client = invoice.job.client

    ClientMailer.overdue_invoice_reminder(invoice).deliver_later if client.email.present?

    return if client.phone.blank?

    Sms::MessageSender.new.send_sms_to_client(
      client: client,
      job: invoice.job,
      template_name: "overdue_invoice_reminder",
      body: "Dobrý den, faktura #{invoice.number} je #{invoice.days_overdue} dní po splatnosti. #{invoice.job.account.name}"
    )
  end
end
