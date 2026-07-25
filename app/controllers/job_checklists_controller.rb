# Nasazení checklistu ze šablony na zakázku.
class JobChecklistsController < ApplicationController
  def create
    job = current_account.jobs.find(params[:job_id])
    checklist_template = current_account.checklist_templates.find(params[:checklist_template_id])

    checklist_template.copy_items_to(job)
    redirect_to job, notice: "Checklist #{checklist_template.name} byl přidán na zakázku."
  end
end
