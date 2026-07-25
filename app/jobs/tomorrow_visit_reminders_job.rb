# Denní připomínka zítřejších termínů zákazníkům.
class TomorrowVisitRemindersJob < ApplicationJob
  queue_as :default

  def perform
    tomorrow_visits.each do |visit|
      client = visit.job.client
      next if client.phone.blank?

      Sms::MessageSender.new.send_sms_to_client(
        client: client,
        job: visit.job,
        template_name: "visit_reminder",
        body: "Dobrý den, připomínáme zítřejší termín v #{I18n.l(visit.starts_at, format: :hour_and_minute)}. #{visit.job.account.name}"
      )
    end
  end

  private

  def tomorrow_visits
    Visit.starting_between(Date.tomorrow.beginning_of_day, Date.tomorrow.end_of_day)
         .where(status: "planned")
         .includes(job: :client)
  end
end
