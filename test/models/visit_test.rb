require "test_helper"

class VisitTest < ActiveSupport::TestCase
  test "vyžaduje začátek i konec" do
    visit = jobs(:havarie).visits.new

    assert_not visit.valid?
    assert_includes visit.errors.attribute_names, :starts_at
    assert_includes visit.errors.attribute_names, :ends_at
  end

  test "konec musí být po začátku" do
    visit = jobs(:havarie).visits.new(
      starts_at: Time.zone.parse("2026-08-03 10:00"),
      ends_at: Time.zone.parse("2026-08-03 09:00")
    )

    assert_not visit.valid?
    assert_includes visit.errors.attribute_names, :ends_at
  end

  test "nepovolí dva překrývající se termíny jednoho technika" do
    overlapping_visit = jobs(:baterie).visits.new(
      user: users(:owner),
      starts_at: Time.zone.parse("2026-07-20 13:00"),
      ends_at: Time.zone.parse("2026-07-20 15:00")
    )

    assert_not overlapping_visit.valid?
    assert_includes overlapping_visit.errors.full_messages.to_sentence, "jiný termín"
  end

  test "navazující termín stejného technika projde" do
    following_visit = jobs(:baterie).visits.new(
      user: users(:owner),
      starts_at: Time.zone.parse("2026-07-20 14:00"),
      ends_at: Time.zone.parse("2026-07-20 16:00")
    )

    assert following_visit.valid?
  end

  test "překryv u dvou různých techniků je v pořádku" do
    visit = jobs(:baterie).visits.new(
      user: users(:technician),
      starts_at: Time.zone.parse("2026-07-20 11:00"),
      ends_at: Time.zone.parse("2026-07-20 13:00")
    )

    assert visit.valid?
  end

  test "databáze sama odmítne překryv, i když se obejde kontrola v modelu" do
    overlapping_visit = jobs(:baterie).visits.new(
      user: users(:owner),
      starts_at: Time.zone.parse("2026-07-20 12:00"),
      ends_at: Time.zone.parse("2026-07-20 13:00")
    )

    assert_raises(ActiveRecord::StatementInvalid) do
      overlapping_visit.save!(validate: false)
    end
  end

  test "spočítá délku termínu v minutách" do
    assert_equal 180, visits(:havarie_dopoledne).duration_in_minutes
  end
end
