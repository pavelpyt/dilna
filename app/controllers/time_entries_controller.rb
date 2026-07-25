class TimeEntriesController < ApplicationController
  # Naskočení do práce. Zakázka je nepovinná — dá se naskočit i „jen tak".
  def create
    time_entry = current_user.time_entries.new(started_at: Time.current, job: requested_job)

    if time_entry.save
      redirect_back fallback_location: today_path, notice: "Naskočil jsi v #{l(time_entry.started_at, format: :hour_and_minute)}."
    else
      redirect_back fallback_location: today_path, alert: time_entry.errors.full_messages.to_sentence
    end
  end

  def update
    time_entry = current_user.time_entries.find(params[:id])
    time_entry.stop!

    redirect_back fallback_location: today_path, notice: "Docházka ukončena, odpracováno #{time_entry.duration_in_hours} h."
  end

  private

  def requested_job
    return nil if params[:job_id].blank?

    current_account.jobs.find(params[:job_id])
  end
end
