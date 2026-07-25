# Štítek se stavem — vizuální podpis celé aplikace. Odstín volá volající,
# překlad stavu na odstín dělá helper u konkrétního modelu.
class TagComponent < ViewComponent::Base
  TONES = {
    plain: "border-line-strong bg-surface-muted text-ink-soft",
    live: "border-petrol-edge bg-petrol-pale text-petrol-ink",
    paid: "border-paid-edge bg-paid-pale text-paid",
    due: "border-due-edge bg-due-pale text-due",
    over: "border-over-edge bg-over-pale text-over"
  }.freeze

  def initialize(label:, tone: :plain)
    @label = label
    @tone = tone
  end

  def tone_class
    TONES.fetch(@tone, TONES[:plain])
  end
end
