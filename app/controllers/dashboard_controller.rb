class DashboardController < ApplicationController
  def show
    @greeting = greeting_for_current_time
    @new_inquiries = current_account.jobs.with_status("inquiry").includes(:client).newest_first
    @open_jobs_count = current_account.jobs.open.count
    @visits_today = current_account.visits
                                   .starting_between(Time.current.beginning_of_day, Time.current.end_of_day)
                                   .includes(:user, job: [ :client, :property ])
                                   .chronological
    @ready_to_invoice_total = current_account.jobs.with_status("completed").sum(&:total_with_vat)
    @overdue_invoices = current_account.invoices.unpaid.includes(job: :client).select(&:overdue?)
  end

  private

  def greeting_for_current_time
    current_hour = Time.current.hour

    return "Dobré ráno" if current_hour < 10
    return "Dobrý den" if current_hour < 18

    "Dobrý večer"
  end
end
