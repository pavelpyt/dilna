require "test_helper"

class InvoicesControllerTest < ActionDispatch::IntegrationTest
  test "majitel vidí seznam faktur" do
    sign_in users(:owner)

    get invoices_path

    assert_response :success
    assert_select "body", /2026-0001/
  end

  test "technik do faktur nesmí" do
    sign_in users(:technician)

    get invoices_path

    assert_redirected_to root_path
  end

  test "vystaví fakturu z dokončené zakázky" do
    sign_in users(:owner)
    job = accounts(:novak).jobs.create!(client: clients(:u_kotvy), title: "Hotová práce", status: "completed")
    job.job_items.create!(description: "Práce", quantity: 2, unit_price: 500)

    assert_difference "Invoice.count", 1 do
      post job_invoice_path(job)
    end

    assert_equal "invoiced", job.reload.status
    assert_equal 1210, job.invoice.total_with_vat
    assert job.invoice.payment_url.present?
  end

  test "z rozpracované zakázky fakturu nevystaví" do
    sign_in users(:owner)

    assert_no_difference "Invoice.count" do
      post job_invoice_path(jobs(:havarie))
    end

    assert_match(/dokončené/, flash[:alert])
  end

  test "druhou fakturu na tutéž zakázku nevystaví" do
    sign_in users(:owner)

    assert_no_difference "Invoice.count" do
      post job_invoice_path(jobs(:servis_dokonceny))
    end

    assert_match(/už fakturu má/, flash[:alert])
  end
end
