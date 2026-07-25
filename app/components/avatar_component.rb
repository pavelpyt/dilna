# Kolečko s iniciálami uživatele. Barva je odvozená z id, aby měl každý technik
# v kalendáři i v seznamech pořád stejnou.
class AvatarComponent < ViewComponent::Base
  BACKGROUND_COLORS = %w[bg-petrol bg-crew-green bg-crew-purple bg-ink].freeze

  SIZES = {
    small: "size-[22px] text-[10px]",
    medium: "size-[34px] text-xs",
    large: "size-8 text-[13px]"
  }.freeze

  def initialize(user:, size: :medium)
    @user = user
    @size = size
  end

  def background_color_class
    BACKGROUND_COLORS[@user.id % BACKGROUND_COLORS.size]
  end

  def size_class
    SIZES.fetch(@size)
  end
end
