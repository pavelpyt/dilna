class JobItemsController < ApplicationController
  before_action :set_job

  def create
    @job_item = @job.job_items.new(job_item_params)
    apply_service_defaults(@job_item)

    if @job_item.save
      redirect_to @job, notice: "Položka byla přidána."
    else
      redirect_to @job, alert: @job_item.errors.full_messages.to_sentence
    end
  end

  def destroy
    @job.job_items.find(params[:id]).destroy
    redirect_to @job, notice: "Položka byla smazána."
  end

  private

  def set_job
    @job = current_account.jobs.find(params[:job_id])
  end

  # Když uživatel vybral službu z ceníku a nechal pole prázdná, doplní se z ceníku.
  def apply_service_defaults(job_item)
    return if job_item.service.nil?
    return if job_item.description.present?

    job_item.copy_from_service(job_item.service)
  end

  def job_item_params
    params.expect(job_item: [ :service_id, :description, :quantity, :unit, :unit_price, :vat_rate ])
  end
end
