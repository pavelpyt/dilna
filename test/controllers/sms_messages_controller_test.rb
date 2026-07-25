require "test_helper"

class SmsMessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:owner)
  end

  test "pošle SMS ze šablony" do
    assert_difference "SmsMessage.count", 1 do
      post job_sms_messages_path(jobs(:havarie), template_name: "on_the_way")
    end

    assert_match(/na cestě/, SmsMessage.order(:created_at).last.body)
  end

  test "neznámou šablonu odmítne" do
    assert_no_difference "SmsMessage.count" do
      post job_sms_messages_path(jobs(:havarie), template_name: "vymyslena")
    end

    assert_match(/Neznámá šablona/, flash[:alert])
  end

  test "klientovi bez telefonu SMS neposílá" do
    jobs(:havarie).client.update!(phone: nil)

    assert_no_difference "SmsMessage.count" do
      post job_sms_messages_path(jobs(:havarie), template_name: "on_the_way")
    end

    assert_match(/nemá telefon/, flash[:alert])
  end
end
