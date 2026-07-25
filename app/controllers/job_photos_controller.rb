class JobPhotosController < ApplicationController
  before_action :set_job

  def create
    job_photo = @job.job_photos.new(job_photo_params)
    job_photo.user = current_user

    if job_photo.save
      redirect_to @job, notice: "Fotka byla nahrána."
    else
      redirect_to @job, alert: "Fotku se nepodařilo nahrát."
    end
  end

  def destroy
    @job.job_photos.find(params[:id]).destroy
    redirect_to @job, notice: "Fotka byla smazána."
  end

  private

  def set_job
    @job = current_account.jobs.find(params[:job_id])
  end

  def job_photo_params
    params.expect(job_photo: [ :image, :caption ])
  end
end
