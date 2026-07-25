require "test_helper"

class InquiriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:owner)
  end

  test "inbox ukáže jen nové poptávky" do
    inquiry = accounts(:novak).jobs.create!(client: clients(:u_kotvy), title: "Nová poptávka z webu", status: "inquiry")

    get inquiries_path

    assert_response :success
    assert_select "body", /Nová poptávka z webu/
    assert_select "body", { count: 0, text: /Havárie — prasklá trubka/ }
    assert_equal "inquiry", inquiry.reload.status
  end

  test "přijetí poptávky ji posune do naceněno" do
    inquiry = accounts(:novak).jobs.create!(client: clients(:u_kotvy), title: "Poptávka k přijetí", status: "inquiry")

    patch job_status_path(inquiry, status: "priced")

    assert_equal "priced", inquiry.reload.status
  end
end
