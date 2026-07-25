# Karta s volitelnou hlavičkou — základní stavební blok všech obrazovek.
# Seznamy řádků si vypínají vnitřní odsazení přes padded: false.
class CardComponent < ViewComponent::Base
  renders_one :header_actions

  def initialize(title: nil, padded: true)
    @title = title
    @padded = padded
  end

  def body_class
    @padded ? "p-[18px]" : ""
  end
end
