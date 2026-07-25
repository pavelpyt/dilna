require "test_helper"

class JobsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:owner)
  end

  test "vypíše zakázky" do
    get jobs_path

    assert_response :success
    assert_select "body", /Havárie/
  end

  test "filtruje podle stavu" do
    get jobs_path(stav: "approved")

    assert_response :success
    assert_select "body", /Výměna baterie/
  end

  test "ukáže detail zakázky i s položkami" do
    get job_path(jobs(:havarie))

    assert_response :success
    assert_select "body", /Instalatérské práce/
  end

  test "založí zakázku" do
    assert_difference "Job.count", 1 do
      post jobs_path, params: { job: { client_id: clients(:u_kotvy).id, title: "Nová zakázka" } }
    end

    assert_redirected_to Job.order(:created_at).last
  end

  test "posune zakázku do povoleného stavu" do
    patch job_status_path(jobs(:havarie), status: "completed")

    assert_equal "completed", jobs(:havarie).reload.status
  end

  test "nepovolený přechod stav nezmění" do
    patch job_status_path(jobs(:havarie), status: "paid")

    assert_equal "in_progress", jobs(:havarie).reload.status
    assert_redirected_to jobs(:havarie)
  end

  test "přidá položku podle ceníku" do
    assert_difference "JobItem.count", 1 do
      post job_job_items_path(jobs(:havarie)),
           params: { job_item: { service_id: services(:instalaterske_prace).id, quantity: 3 } }
    end

    assert_equal "Instalatérské práce", JobItem.order(:created_at).last.description
  end
end
