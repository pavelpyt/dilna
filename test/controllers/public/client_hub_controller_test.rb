require "test_helper"

class Public::ClientHubControllerTest < ActionDispatch::IntegrationTest
  test "s platným tokenem ukáže zakázku i nabídku bez přihlášení" do
    get client_hub_path(public_tokens(:baterie_odkaz).token)

    assert_response :success
    assert_select "body", /Rozvody vody v kuchyni/
    assert_select "body", /Schválit nabídku/
  end

  test "vyhledávače stránku indexovat nemají" do
    get client_hub_path(public_tokens(:baterie_odkaz).token)

    assert_match(/noindex/, response.body)
  end

  test "neznámý token vrátí 404" do
    get client_hub_path("token-ktery-neexistuje")

    assert_response :not_found
  end

  test "propadlý token vrátí 404" do
    get client_hub_path(public_tokens(:propadly_odkaz).token)

    assert_response :not_found
  end

  test "schválení nabídky posune zakázku" do
    post client_hub_quote_decision_path(public_tokens(:baterie_odkaz).token, decision: "approve")

    assert_equal "approved", quotes(:baterie_nabidka).reload.status
    assert_equal "approved", jobs(:baterie_naceneno).reload.status
  end

  test "zamítnutí nabídky posune zakázku do zamítnuto" do
    post client_hub_quote_decision_path(public_tokens(:baterie_odkaz).token, decision: "reject")

    assert_equal "rejected", jobs(:baterie_naceneno).reload.status
  end

  test "už rozhodnutou nabídku nejde schválit podruhé" do
    quotes(:baterie_nabidka).approve_by_customer!

    post client_hub_quote_decision_path(public_tokens(:baterie_odkaz).token, decision: "reject")

    assert_equal "approved", quotes(:baterie_nabidka).reload.status
  end
end
