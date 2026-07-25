class CalendarController < ApplicationController
  def show
    @technicians = current_account.users.order(:last_name, :first_name)
  end
end
