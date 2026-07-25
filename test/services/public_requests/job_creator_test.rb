require "test_helper"

class PublicRequests::JobCreatorTest < ActiveSupport::TestCase
  test "z poptávky udělá nového klienta, adresu i zakázku" do
    job_request_form = JobRequestForm.new(
      client_name: "Marek Beneš", phone: "+420 733 908 442",
      street: "Sokolská 60", city: "Praha 2", postal_code: "120 00",
      title: "Netopí radiátor", description: "Zůstává studený."
    )

    job = PublicRequests::JobCreator.new(accounts(:novak)).create_job_from_public_form(job_request_form)

    assert_equal "inquiry", job.status
    assert_equal "Marek Beneš", job.client.name
    assert_equal "Sokolská 60", job.property.street
  end

  test "stálého zákazníka pozná podle telefonu a nezaloží ho znovu" do
    job_request_form = JobRequestForm.new(
      client_name: "Jana S.", phone: clients(:svobodova).phone,
      street: "Korunní 88", city: "Praha 2", title: "Kape kohoutek"
    )

    assert_no_difference "Client.count" do
      job = PublicRequests::JobCreator.new(accounts(:novak)).create_job_from_public_form(job_request_form)

      assert_equal clients(:svobodova), job.client
    end
  end

  test "existující adresu klienta použije znovu" do
    job_request_form = JobRequestForm.new(
      client_name: "Jana S.", phone: clients(:svobodova).phone,
      street: properties(:svobodova_byt).street, city: properties(:svobodova_byt).city,
      title: "Kape kohoutek"
    )

    assert_no_difference "Property.count" do
      job = PublicRequests::JobCreator.new(accounts(:novak)).create_job_from_public_form(job_request_form)

      assert_equal properties(:svobodova_byt), job.property
    end
  end
end
