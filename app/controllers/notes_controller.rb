class NotesController < ApplicationController
  before_action :set_job

  def create
    note = @job.notes.new(note_params)
    note.user = current_user

    if note.save
      redirect_to @job, notice: "Poznámka byla přidána."
    else
      redirect_to @job, alert: "Poznámka nesmí být prázdná."
    end
  end

  def destroy
    @job.notes.find(params[:id]).destroy
    redirect_to @job, notice: "Poznámka byla smazána."
  end

  private

  def set_job
    @job = current_account.jobs.find(params[:job_id])
  end

  def note_params
    params.expect(note: [ :body ])
  end
end
