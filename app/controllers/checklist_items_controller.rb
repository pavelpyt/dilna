class ChecklistItemsController < ApplicationController
  before_action :set_job

  def create
    checklist_item = @job.checklist_items.new(checklist_item_params)

    if checklist_item.save
      redirect_to @job, notice: "Položka checklistu byla přidána."
    else
      redirect_to @job, alert: "Položka checklistu musí mít text."
    end
  end

  # Odškrtnutí a vrácení zpátky je ta samá akce — mění se jen stav položky.
  def update
    checklist_item = @job.checklist_items.find(params[:id])
    checklist_item.toggle_completed_by!(current_user)

    redirect_to @job
  end

  def destroy
    @job.checklist_items.find(params[:id]).destroy
    redirect_to @job, notice: "Položka checklistu byla smazána."
  end

  private

  def set_job
    @job = current_account.jobs.find(params[:job_id])
  end

  def checklist_item_params
    params.expect(checklist_item: [ :label, :position ])
  end
end
