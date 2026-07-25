require "test_helper"

class PublicTokenTest < ActiveSupport::TestCase
  test "vygeneruje si náhodný token" do
    public_token = jobs(:havarie).public_tokens.create!

    assert_equal 32, public_token.token.length
  end

  test "propadlý token není mezi platnými" do
    assert_includes PublicToken.still_valid, public_tokens(:baterie_odkaz)
    assert_not_includes PublicToken.still_valid, public_tokens(:propadly_odkaz)
  end

  test "zakázka si platný odkaz drží a nevyrábí nový" do
    job = jobs(:baterie_naceneno)

    assert_no_difference "PublicToken.count" do
      assert_equal public_tokens(:baterie_odkaz), job.public_token_for_client_hub
    end
  end

  test "zakázka bez platného odkazu si nový vyrobí" do
    job = jobs(:havarie)

    assert_difference "PublicToken.count", 1 do
      job.public_token_for_client_hub
    end
  end
end
