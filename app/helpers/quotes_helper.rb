module QuotesHelper
  STATUS_TONES = {
    "draft" => :plain,
    "sent" => :due,
    "approved" => :paid,
    "rejected" => :over
  }.freeze

  def quote_status_tone(quote)
    STATUS_TONES.fetch(quote.status, :plain)
  end
end
