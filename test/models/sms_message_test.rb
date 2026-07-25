require "test_helper"

class SmsMessageTest < ActiveSupport::TestCase
  test "vyžaduje text" do
    sms_message = clients(:u_kotvy).sms_messages.new

    assert_not sms_message.valid?
    assert_includes sms_message.errors.attribute_names, :body
  end

  test "označení za odeslané zapíše čas a id od brány" do
    sms_message = clients(:u_kotvy).sms_messages.create!(body: "Test")
    sms_message.mark_as_sent!("sms-mock-abc")

    assert sms_message.sent?
    assert_equal "sms-mock-abc", sms_message.external_id
    assert_not_nil sms_message.sent_at
  end
end
