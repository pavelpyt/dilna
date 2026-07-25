module JobsHelper
  STATUS_TONES = {
    "inquiry" => :live,
    "priced" => :plain,
    "quote_sent" => :due,
    "approved" => :live,
    "scheduled" => :plain,
    "in_progress" => :live,
    "completed" => :paid,
    "invoiced" => :due,
    "paid" => :paid,
    "complaint" => :over,
    "rejected" => :over,
    "cancelled" => :plain
  }.freeze

  def job_status_tone(job)
    STATUS_TONES.fetch(job.status, :plain)
  end

  def job_status_label(job)
    t("jobs.statuses.#{job.status}")
  end

  def job_status_filter_options
    Job::STATUSES.map { |status| [ t("jobs.statuses.#{status}"), status ] }
  end

  def service_options_for_select(services)
    services.map { |service| [ "#{service.name} — #{number_to_currency(service.unit_price)} / #{service.unit}", service.id ] }
  end

  def property_options_for_select(client)
    client.properties.order(:label, :street).map { |property| [ property.display_label, property.id ] }
  end
end
