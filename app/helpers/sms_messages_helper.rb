module SmsMessagesHelper
  STATUS_TONES = {
    "queued" => :plain,
    "sent" => :paid,
    "failed" => :over
  }.freeze

  def sms_message_status_tone(sms_message)
    STATUS_TONES.fetch(sms_message.status, :plain)
  end
end
