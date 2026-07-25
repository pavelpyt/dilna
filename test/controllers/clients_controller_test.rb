require "test_helper"

class ClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:owner)
  end

  test "vypíše klienty firmy" do
    get clients_path

    assert_response :success
    assert_select "body", /Restaurace U Kotvy/
  end

  test "ukáže detail klienta i s místy a kontakty" do
    get client_path(clients(:u_kotvy))

    assert_response :success
    assert_select "body", /Bělehradská 45/
    assert_select "body", /Martin Kolář/
  end

  test "založí klienta" do
    assert_difference "Client.count", 1 do
      post clients_path, params: { client: { client_type: "person", name: "Nový klient" } }
    end

    assert_redirected_to Client.order(:created_at).last
  end

  test "nepustí k cizímu klientovi" do
    other_account = Account.create!(name: "Jiná firma")
    foreign_client = other_account.clients.create!(name: "Cizí klient")

    get client_path(foreign_client)

    assert_response :not_found
  end
end
