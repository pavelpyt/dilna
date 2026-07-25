class JobsController < ApplicationController
  before_action :set_job, only: [ :show, :edit, :update, :destroy ]

  def index
    @status_filter = params[:stav]
    @jobs = current_account.jobs.includes(:client, :property).newest_first
    @jobs = @jobs.with_status(@status_filter) if @status_filter.present?
  end

  def show
    @job_items = @job.job_items.includes(:service)
    @notes = @job.notes.includes(:user)
    @job_photos = @job.job_photos.includes(:user, image_attachment: :blob)
    @new_note = @job.notes.new
    @new_job_item = @job.job_items.new(quantity: 1)
    @available_services = current_account.services.available
    @visits = @job.visits.includes(:user)
    @new_visit = @job.visits.new(starts_at: Time.current.tomorrow.change(hour: 8), ends_at: Time.current.tomorrow.change(hour: 10))
    @technicians = current_account.users.order(:last_name, :first_name)
    @quote = @job.current_quote
    @client_hub_url = client_hub_url(@job.public_token_for_client_hub.token)
  end

  def new
    @job = current_account.jobs.new(client_id: params[:client_id])
  end

  def create
    @job = current_account.jobs.new(job_params)

    if @job.save
      redirect_to @job, notice: "Zakázka byla založena."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @job.update(job_params)
      redirect_to @job, notice: "Zakázka byla upravena."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @job.destroy
    redirect_to jobs_path, notice: "Zakázka byla smazána."
  end

  private

  def set_job
    @job = current_account.jobs.find(params[:id])
  end

  def job_params
    params.expect(job: [ :client_id, :property_id, :title, :description,
                         :scheduled_start_at, :scheduled_end_at ])
  end
end
