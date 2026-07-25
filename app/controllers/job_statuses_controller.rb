# Posun zakázky do dalšího stavu. Vlastní controller, protože je to jediná
# akce nad zakázkou, která má vlastní pravidla — ne další sloveso v JobsController.
class JobStatusesController < ApplicationController
  def update
    job = current_account.jobs.find(params[:job_id])
    new_status = params[:status]

    unless job.can_change_status_to?(new_status)
      redirect_to job, alert: "Zakázku nejde z tohohle stavu takhle posunout."
      return
    end

    job.change_status_to!(new_status)
    redirect_to job, notice: "Zakázka je teď ve stavu #{t("jobs.statuses.#{new_status}")}."
  end
end
