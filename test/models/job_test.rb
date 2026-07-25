require "test_helper"

class JobTest < ActiveSupport::TestCase
  test "vyžaduje název" do
    job = accounts(:novak).jobs.new(client: clients(:u_kotvy))

    assert_not job.valid?
    assert_includes job.errors.attribute_names, :title
  end

  test "čísluje zakázky po sobě v rámci roku a firmy" do
    fresh_account = Account.create!(name: "Nová firma")
    fresh_client = fresh_account.clients.create!(name: "První klient")

    first_job = fresh_account.jobs.create!(client: fresh_client, title: "První zakázka")
    second_job = fresh_account.jobs.create!(client: fresh_client, title: "Druhá zakázka")

    assert_equal "#{Date.current.year}-0001", first_job.number
    assert_equal "#{Date.current.year}-0002", second_job.number
  end

  test "nepovolí místo jiného klienta" do
    job = accounts(:novak).jobs.new(
      client: clients(:svobodova),
      property: properties(:u_kotvy_provozovna),
      title: "Zakázka na cizí adrese"
    )

    assert_not job.valid?
    assert_includes job.errors.attribute_names, :property
  end

  test "povolí jen přechody ze stavového automatu" do
    job = jobs(:havarie)

    assert job.can_change_status_to?("completed")
    assert_not job.can_change_status_to?("paid")
  end

  test "zakázaný přechod skončí chybou" do
    job = jobs(:havarie)

    assert_raises(ArgumentError) { job.change_status_to!("paid") }
  end

  test "povolený přechod stav změní" do
    job = jobs(:havarie)
    job.change_status_to!("completed")

    assert_equal "completed", job.reload.status
  end

  test "sečte položky bez DPH i s DPH" do
    job = jobs(:havarie)

    assert_equal 2_465, job.total_without_vat
    assert_in_delta 2_982.65, job.total_with_vat, 0.01
  end
end
