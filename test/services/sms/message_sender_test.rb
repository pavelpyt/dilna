require "test_helper"

class Sms::MessageSenderTest < ActiveSupport::TestCase
  test "odeslání zapíše zprávu a zařadí ji do fronty" do
    assert_difference "SmsMessage.count", 1 do
      assert_enqueued_with(job: SendSmsMessageJob) do
        Sms::MessageSender.new.send_sms_to_client(
          client: clients(:u_kotvy), job: jobs(:havarie), body: "Jsme na cestě.", template_name: "on_the_way"
        )
      end
    end
  end

  test "mock doručení označí zprávu za odeslanou" do
    sms_message = clients(:u_kotvy).sms_messages.create!(body: "Test")

    Sms::MessageSender.new.deliver(sms_message)

    assert sms_message.reload.sent?
    assert_match(/\Asms-mock-/, sms_message.external_id)
  end

  test "klientovi bez telefonu se nedoručí" do
    client = accounts(:novak).clients.create!(name: "Bez telefonu")
    sms_message = client.sms_messages.create!(body: "Test")

    Sms::MessageSender.new.deliver(sms_message)

    assert_equal "failed", sms_message.reload.status
  end

  test "šablona poskládá text z údajů zakázky" do
    body = Sms::Templates.body_for("on_the_way", jobs(:havarie))

    assert_match(/jsme na cestě/, body)
    assert_match(/Bělehradská 45/, body)
  end
end
