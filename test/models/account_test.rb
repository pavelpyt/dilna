require "test_helper"

class AccountTest < ActiveSupport::TestCase
  test "vyžaduje název" do
    account = Account.new(slug: "bez-nazvu")

    assert_not account.valid?
    assert_includes account.errors.attribute_names, :name
  end

  test "odvodí slug z názvu, když není zadaný" do
    account = Account.create!(name: "Novák — topení a voda 2")

    assert_equal "novak-topeni-a-voda-2", account.slug
  end

  test "nepovolí dvě firmy se stejným slugem" do
    duplicate_account = Account.new(name: "Jiná firma", slug: accounts(:novak).slug)

    assert_not duplicate_account.valid?
    assert_includes duplicate_account.errors.attribute_names, :slug
  end

  test "nepovolí slug s mezerami" do
    account = Account.new(name: "Firma", slug: "s mezerou")

    assert_not account.valid?
    assert_includes account.errors.attribute_names, :slug
  end
end
