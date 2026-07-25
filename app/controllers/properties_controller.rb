class PropertiesController < ApplicationController
  before_action :set_client
  before_action :set_property, only: [ :edit, :update, :destroy ]

  def new
    @property = @client.properties.new
  end

  def create
    @property = @client.properties.new(property_params)

    if @property.save
      redirect_to @client, notice: "Místo bylo přidáno."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @property.update(property_params)
      redirect_to @client, notice: "Místo bylo upraveno."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @property.destroy
    redirect_to @client, notice: "Místo bylo smazáno."
  end

  private

  def set_client
    @client = current_account.clients.find(params[:client_id])
  end

  def set_property
    @property = @client.properties.find(params[:id])
  end

  def property_params
    params.expect(property: [ :label, :street, :city, :postal_code, :note ])
  end
end
