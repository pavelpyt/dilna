# Export odpracovaných hodin do Excelu. Mzdy nepočítáme — jen surová data ven,
# zbytek řeší účetní.
class TeamHoursExportsController < ApplicationController
  def show
    authorize User, :index?

    from_date = parsed_date(params[:od]) || Date.current.beginning_of_month
    to_date = parsed_date(params[:do]) || Date.current.end_of_month

    send_data build_workbook(from_date, to_date).to_stream.read,
              filename: "hodiny-#{from_date}-#{to_date}.xlsx",
              type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end

  private

  def parsed_date(value)
    Date.parse(value) if value.present?
  rescue Date::Error
    nil
  end

  def build_workbook(from_date, to_date)
    package = Axlsx::Package.new
    sheet = package.workbook.add_worksheet(name: "Hodiny")

    sheet.add_row [ "Technik", "Datum", "Od", "Do", "Hodin", "Zakázka" ]

    exported_time_entries(from_date, to_date).each do |time_entry|
      sheet.add_row [
        time_entry.user.full_name,
        I18n.l(time_entry.started_at.to_date, format: :default),
        I18n.l(time_entry.started_at, format: :hour_and_minute),
        I18n.l(time_entry.ended_at, format: :hour_and_minute),
        time_entry.duration_in_hours,
        time_entry.job&.title
      ]
    end

    package
  end

  def exported_time_entries(from_date, to_date)
    current_account.time_entries
                   .finished
                   .started_between(from_date.beginning_of_day, to_date.end_of_day)
                   .includes(:user, :job)
                   .order(:started_at)
  end
end
