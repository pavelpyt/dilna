class UsersController < ApplicationController
  before_action :set_user, only: [ :edit, :update, :destroy ]

  def index
    authorize User
    @team_members = current_account.users.order(:last_name, :first_name)
    @week_start = Date.current.beginning_of_week
    @time_entries_today = current_account.time_entries
                                         .includes(:user, :job)
                                         .started_between(Time.current.beginning_of_day, Time.current.end_of_day)
                                         .newest_first
  end

  def new
    authorize User
    @user = current_account.users.new(role: "staff")
  end

  def create
    authorize User
    @user = current_account.users.new(user_params)

    if @user.save
      redirect_to users_path, notice: "Člen týmu byl přidán."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @user
  end

  def update
    authorize @user

    if @user.update(user_params_without_blank_password)
      redirect_to users_path, notice: "Člen týmu byl upraven."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @user
    @user.destroy
    redirect_to users_path, notice: "Člen týmu byl odebrán."
  end

  private

  def set_user
    @user = current_account.users.find(params[:id])
  end

  def user_params
    params.expect(user: [ :first_name, :last_name, :email, :phone, :role, :password ])
  end

  # Prázdné heslo při úpravě znamená „nech to staré".
  def user_params_without_blank_password
    submitted_params = user_params
    submitted_params.delete(:password) if submitted_params[:password].blank?
    submitted_params
  end
end
