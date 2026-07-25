class ServicesController < ApplicationController
  before_action :set_service, only: [ :edit, :update, :destroy ]

  def index
    authorize Service
    @services = current_account.services.by_name
  end

  def new
    authorize Service
    @service = current_account.services.new(vat_rate: 21, unit: "ks")
  end

  def create
    authorize Service
    @service = current_account.services.new(service_params)

    if @service.save
      redirect_to services_path, notice: "Položka ceníku byla přidána."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @service
  end

  def update
    authorize @service

    if @service.update(service_params)
      redirect_to services_path, notice: "Položka ceníku byla upravena."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @service
    @service.destroy
    redirect_to services_path, notice: "Položka ceníku byla smazána."
  end

  private

  def set_service
    @service = current_account.services.find(params[:id])
  end

  def service_params
    params.expect(service: [ :name, :unit, :unit_price, :vat_rate, :margin_percent, :archived ])
  end
end
