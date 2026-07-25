require "test_helper"

# Hlavní tok celé aplikace, tak jak ho popisuje zadání:
# poptávka z webu → přijetí → nacenění → nabídka → schválení zákazníkem →
# termín v kalendáři → práce → faktura → zaplacení.
class MainFlowTest < ActionDispatch::IntegrationTest
  test "od poptávky z webu po zaplacenou fakturu" do
    account = accounts(:novak)

    # Zákazník odešle poptávku z veřejného formuláře.
    assert_difference "Job.count", 1 do
      post public_job_requests_path(account.slug), params: {
        job_request_form: {
          client_name: "Kavárna Zrno s.r.o.",
          phone: "+420 775 220 118",
          email: "provoz@kavarnazrno.cz",
          street: "Lublaňská 12",
          city: "Praha 2",
          title: "Rozvody vody do nového baru",
          description: "Stavíme bar, potřebujeme vodu a odpad."
        }
      }
    end

    job = Job.order(:created_at).last

    assert_equal "inquiry", job.status
    assert_equal "Kavárna Zrno s.r.o.", job.client.name

    # Řemeslník ji vidí v inboxu a přijme ji.
    sign_in users(:owner)

    get inquiries_path
    assert_response :success
    assert_select "body", /Rozvody vody do nového baru/

    patch job_status_path(job, status: "priced")
    assert_equal "priced", job.reload.status

    # Nacení ji položkami z ceníku.
    post job_job_items_path(job), params: {
      job_item: { service_id: services(:instalaterske_prace).id, quantity: 8 }
    }

    assert_equal 5_200, job.reload.total_without_vat

    # Vystaví nabídku — zakázka se posune a zákazníkovi odejde e-mail.
    assert_difference "Quote.count", 1 do
      assert_enqueued_emails 1 do
        post job_quotes_path(job)
      end
    end

    assert_equal "quote_sent", job.reload.status

    # Zákazník otevře client hub přes token a nabídku schválí.
    client_hub_token = job.public_token_for_client_hub.token

    get client_hub_path(client_hub_token)
    assert_response :success
    assert_select "body", /Schválit nabídku/

    post client_hub_quote_decision_path(client_hub_token, decision: "approve")

    assert_equal "approved", job.reload.status
    assert job.current_quote.approved?

    # Řemeslník naplánuje termín technikovi.
    assert_difference "Visit.count", 1 do
      post job_visits_path(job), params: {
        visit: {
          user_id: users(:technician).id,
          starts_at: Date.tomorrow.iso8601 + "T08:00",
          ends_at: Date.tomorrow.iso8601 + "T12:00"
        }
      }
    end

    patch job_status_path(job, status: "scheduled")

    # Technik vidí termín ve svém Dnešku, až bude jeho den.
    travel_to Date.tomorrow.noon do
      sign_in users(:technician)

      get today_path
      assert_response :success
      assert_select "body", /Rozvody vody do nového baru/
    end

    # Práce proběhne a je hotová.
    sign_in users(:owner)
    patch job_status_path(job, status: "in_progress")
    patch job_status_path(job, status: "completed")

    assert_equal "completed", job.reload.status

    # Vystaví se faktura přes Fakturoid (v MVP mock) i platební odkaz.
    assert_difference "Invoice.count", 1 do
      post job_invoice_path(job)
    end

    invoice = job.reload.invoice

    assert_equal "invoiced", job.status
    assert_equal job.total_with_vat, invoice.total_with_vat
    assert invoice.pdf_url.present?
    assert invoice.payment_url.present?

    # Zákazník fakturu zaplatí z client hubu.
    assert_difference "Payment.count", 1 do
      post client_hub_payment_path(client_hub_token)
    end

    assert invoice.reload.paid?
    assert_equal "paid", job.reload.status
  end
end
