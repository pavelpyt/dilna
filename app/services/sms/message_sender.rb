module Sms
  # Jediné místo, přes které odchází SMS zákazníkovi. Odeslání se vždycky
  # zapíše do SmsMessage, ať je doložitelné kdy, komu a co odešlo.
  #
  # Dokud není napojení na bránu hotové, běží mock: zaloguje se akce a vrátí
  # se realistické id od poskytovatele. Přepínač je ENV SMS_GATEWAY_ENABLED.
  class MessageSender
    def send_sms_to_client(client:, body:, job: nil, template_name: nil)
      sms_message = client.sms_messages.create!(body: body, job: job, template_name: template_name)

      SendSmsMessageJob.perform_later(sms_message.id)
      sms_message
    end

    # Volá se z fronty, ne z requestu.
    def deliver(sms_message)
      raise NotImplementedError, "Napojení na SMS bránu zatím není hotové." if real_gateway_enabled?

      if sms_message.client.phone.blank?
        sms_message.mark_as_failed!
        return sms_message
      end

      Rails.logger.info("[mock SMS brána] #{sms_message.client.phone}: #{sms_message.body}")
      sms_message.mark_as_sent!("sms-mock-#{SecureRandom.hex(6)}")
      sms_message
    end

    private

    def real_gateway_enabled?
      ENV["SMS_GATEWAY_ENABLED"] == "true"
    end
  end
end
