require "test_helper"

class JobRequestFormTest < ActiveSupport::TestCase
  test "vyžaduje jméno, adresu a popis toho, co je potřeba" do
    job_request_form = JobRequestForm.new

    assert_not job_request_form.valid?
    assert_includes job_request_form.errors.attribute_names, :client_name
    assert_includes job_request_form.errors.attribute_names, :street
    assert_includes job_request_form.errors.attribute_names, :city
    assert_includes job_request_form.errors.attribute_names, :title
  end

  test "vyžaduje aspoň jeden kontakt" do
    job_request_form = JobRequestForm.new(
      client_name: "Marek Beneš", street: "Sokolská 60", city: "Praha 2", title: "Netopí radiátor"
    )

    assert_not job_request_form.valid?
    assert_includes job_request_form.errors.attribute_names, :phone
  end

  test "s telefonem projde" do
    job_request_form = JobRequestForm.new(
      client_name: "Marek Beneš", phone: "+420 733 908 442",
      street: "Sokolská 60", city: "Praha 2", title: "Netopí radiátor"
    )

    assert job_request_form.valid?
  end
end
