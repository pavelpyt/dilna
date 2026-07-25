class ClientsController < ApplicationController
  before_action :set_client, only: [ :show, :edit, :update, :destroy ]

  def index
    @search_term = params[:hledat]
    @clients = current_account.clients.matching(@search_term)
  end

  def show
    @properties = @client.properties.order(:label, :street)
    @contacts = @client.contacts.order(:last_name, :first_name)
    @jobs = @client.jobs.includes(:property).newest_first
    @invoices = @client.invoices.includes(:job).newest_first
    @sms_messages = @client.sms_messages.newest_first.limit(10)
  end

  def new
    @client = current_account.clients.new(client_type: "company")
  end

  def create
    @client = current_account.clients.new(client_params)

    if @client.save
      redirect_to @client, notice: "Klient byl založen."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @client.update(client_params)
      redirect_to @client, notice: "Klient byl upraven."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_path, notice: "Klient byl smazán."
  end

  private

  def set_client
    @client = current_account.clients.find(params[:id])
  end

  def client_params
    params.expect(client: [ :client_type, :name, :company_registration_number,
                            :vat_identification_number, :email, :phone, :note ])
  end
end
