# Kolečko s iniciálami. Používá se pro uživatele i pro kontaktní osoby klienta —
# obojí umí full_name a initials.
#
# Barva technika se odvozuje z id, aby měl v kalendáři i v seznamech pořád stejnou.
# Kontaktní osoby jsou neutrálně tmavé, ať se nepletou s techniky.
class AvatarComponent < ViewComponent::Base
  CREW_COLORS = %w[bg-petrol bg-crew-green bg-crew-purple bg-ink].freeze

  SIZES = {
    small: "size-[22px] text-[10px]",
    medium: "size-[34px] text-xs",
    large: "size-8 text-[13px]"
  }.freeze

  def initialize(person:, size: :medium, variant: :crew)
    @person = person
    @size = size
    @variant = variant
  end

  def background_color_class
    return "bg-ink-soft" if @variant == :neutral

    CREW_COLORS[@person.id % CREW_COLORS.size]
  end

  def size_class
    SIZES.fetch(@size)
  end
end
