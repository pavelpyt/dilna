class SendSmsMessageJob < ApplicationJob
  queue_as :default

  def perform(sms_message_id)
    sms_message = SmsMessage.find(sms_message_id)

    Sms::MessageSender.new.deliver(sms_message)
  end
end
