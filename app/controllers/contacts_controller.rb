class ContactsController < ApplicationController
  before_action :set_client
  before_action :set_contact, only: [ :edit, :update, :destroy ]

  def new
    @contact = @client.contacts.new
  end

  def create
    @contact = @client.contacts.new(contact_params)

    if @contact.save
      redirect_to @client, notice: "Kontakt byl přidán."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @contact.update(contact_params)
      redirect_to @client, notice: "Kontakt byl upraven."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @contact.destroy
    redirect_to @client, notice: "Kontakt byl smazán."
  end

  private

  def set_client
    @client = current_account.clients.find(params[:client_id])
  end

  def set_contact
    @contact = @client.contacts.find(params[:id])
  end

  def contact_params
    params.expect(contact: [ :first_name, :last_name, :position, :email, :phone ])
  end
end
