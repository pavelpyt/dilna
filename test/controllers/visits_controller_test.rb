require "test_helper"

class VisitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:owner)
  end

  test "kalendář se zobrazí" do
    get calendar_path

    assert_response :success
    assert_select "body", /Termíny se přesouvají tažením/
  end

  test "vrátí termíny jako JSON pro kalendář" do
    get visits_path(format: :json, start: "2026-07-20T00:00:00+02:00", end: "2026-07-27T00:00:00+02:00")

    assert_response :success
    events = response.parsed_body

    assert_equal 3, events.size
    assert_equal "Havárie — prasklá trubka", events.first["title"]
    assert_equal "Petr Novák", events.first["extendedProps"]["technician"]
  end

  test "naplánuje termín ze zakázky" do
    assert_difference "Visit.count", 1 do
      post job_visits_path(jobs(:havarie)), params: {
        visit: {
          user_id: users(:technician).id,
          starts_at: "2026-08-03T08:00",
          ends_at: "2026-08-03T10:00"
        }
      }
    end

    assert_redirected_to jobs(:havarie)
  end

  test "kolidující termín se neuloží" do
    assert_no_difference "Visit.count" do
      post job_visits_path(jobs(:havarie)), params: {
        visit: {
          user_id: users(:owner).id,
          starts_at: "2026-07-20T12:00",
          ends_at: "2026-07-20T13:00"
        }
      }
    end

    assert_redirected_to jobs(:havarie)
    assert_match(/jiný termín/, flash[:alert])
  end

  test "přetažení termínu ho přesune" do
    patch visit_path(visits(:havarie_dopoledne)), params: {
      visit: { starts_at: "2026-07-20T15:00:00+02:00", ends_at: "2026-07-20T17:00:00+02:00" }
    }

    assert_response :no_content
    assert_equal Time.zone.parse("2026-07-20 15:00"), visits(:havarie_dopoledne).reload.starts_at
  end

  test "přetažení do kolize se stejným technikem vrátí chybu" do
    # havarie_dopoledne i havarie_druhy_den patří stejnému technikovi.
    patch visit_path(visits(:havarie_dopoledne)), params: {
      visit: { starts_at: "2026-07-22T09:00:00+02:00", ends_at: "2026-07-22T11:00:00+02:00" }
    }

    assert_response :unprocessable_entity
    assert_match(/jiný termín/, response.parsed_body["error"])
  end
end
