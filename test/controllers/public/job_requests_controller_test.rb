require "test_helper"

class Public::JobRequestsControllerTest < ActionDispatch::IntegrationTest
  test "formulář je veřejný, bez přihlášení" do
    get public_job_request_path(accounts(:novak).slug)

    assert_response :success
    assert_select "body", /Nezávazná poptávka/
  end

  test "neznámá firma vrátí 404" do
    get public_job_request_path("neexistujici-firma")

    assert_response :not_found
  end

  test "odeslaná poptávka založí zakázku ve stavu poptávka" do
    assert_difference "Job.count", 1 do
      post public_job_requests_path(accounts(:novak).slug), params: {
        job_request_form: {
          client_name: "Kavárna Zrno", phone: "+420 775 220 118",
          street: "Lublaňská 12", city: "Praha 2", title: "Rozvody vody"
        }
      }
    end

    assert_redirected_to public_job_request_sent_path(accounts(:novak).slug)
    assert_equal "inquiry", Job.order(:created_at).last.status
  end

  test "neúplný formulář zakázku nezaloží" do
    assert_no_difference "Job.count" do
      post public_job_requests_path(accounts(:novak).slug), params: {
        job_request_form: { client_name: "Bez kontaktu", street: "Ulice 1", city: "Praha", title: "Něco" }
      }
    end

    assert_response :unprocessable_entity
  end
end
