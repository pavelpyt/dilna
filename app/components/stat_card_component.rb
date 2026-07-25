# Dlaždice s číslem — používá ji přehled i stránka týmu.
class StatCardComponent < ViewComponent::Base
  def initialize(label:, value:, tone: :ink)
    @label = label
    @value = value
    @tone = tone
  end

  def value_class
    @tone == :over ? "text-over" : "text-ink"
  end
end
