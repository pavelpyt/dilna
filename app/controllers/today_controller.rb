# „Dnešek" — obrazovka pro technika v terénu. Jeho dnešní termíny,
# docházka a nic navíc.
class TodayController < ApplicationController
  def show
    @visits_today = current_user.visits
                                .starting_between(Time.current.beginning_of_day, Time.current.end_of_day)
                                .includes(job: [ :client, :property ])
                                .chronological
    @running_time_entry = current_user.running_time_entry
    @hours_this_week = current_user.hours_worked_between(Date.current.beginning_of_week, Date.current.end_of_week.end_of_day)
  end
end
