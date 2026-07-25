require "test_helper"

class QuotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:owner)
  end

  test "vystaví nabídku z naceněné zakázky" do
    job = accounts(:novak).jobs.create!(client: clients(:u_kotvy), title: "K nacenění", status: "priced")
    job.job_items.create!(description: "Práce", quantity: 1, unit_price: 500)

    assert_difference "Quote.count", 1 do
      post job_quotes_path(job)
    end

    assert_equal "quote_sent", job.reload.status
  end

  test "bez položek nabídku nevystaví" do
    job = accounts(:novak).jobs.create!(client: clients(:u_kotvy), title: "Prázdná", status: "priced")

    assert_no_difference "Quote.count" do
      post job_quotes_path(job)
    end

    assert_match(/žádné položky/, flash[:alert])
  end

  test "z rozpracované zakázky nabídku nevystaví" do
    assert_no_difference "Quote.count" do
      post job_quotes_path(jobs(:havarie))
    end

    assert_match(/naceněné/, flash[:alert])
  end
end
