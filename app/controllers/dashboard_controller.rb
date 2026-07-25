class DashboardController < ApplicationController
  def show
    @greeting = greeting_for_current_time
    @new_inquiries = current_account.jobs.with_status("inquiry").includes(:client).newest_first
    @open_jobs_count = current_account.jobs.open.count
  end

  private

  def greeting_for_current_time
    current_hour = Time.current.hour

    return "Dobré ráno" if current_hour < 10
    return "Dobrý den" if current_hour < 18

    "Dobrý večer"
  end
end
