require "test_helper"

class ClientTest < ActiveSupport::TestCase
  test "vyžaduje název" do
    client = accounts(:novak).clients.new(client_type: "company")

    assert_not client.valid?
    assert_includes client.errors.attribute_names, :name
  end

  test "nepovolí neznámý typ klienta" do
    client = clients(:u_kotvy)
    client.client_type = "instituce"

    assert_not client.valid?
    assert_includes client.errors.attribute_names, :client_type
  end

  test "hledá podle jména" do
    assert_includes Client.matching("kotvy"), clients(:u_kotvy)
    assert_not_includes Client.matching("kotvy"), clients(:svobodova)
  end

  test "hledá podle adresy nemovitosti" do
    assert_includes Client.matching("Korunní"), clients(:svobodova)
  end

  test "prázdné hledání vrátí všechny klienty" do
    assert_includes Client.matching(""), clients(:u_kotvy)
    assert_includes Client.matching(nil), clients(:svobodova)
  end
end
