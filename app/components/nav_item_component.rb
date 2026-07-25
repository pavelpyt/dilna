class NavItemComponent < ViewComponent::Base
  BASE_CLASS = "flex w-full items-center gap-3 rounded-md px-3 py-2.5 text-[14.5px] font-medium transition"
  private_constant :BASE_CLASS

  def initialize(label:, path:, icon:, active:, badge_count: nil)
    @label = label
    @path = path
    @icon = icon
    @active = active
    @badge_count = badge_count
  end

  def link_class
    return "#{BASE_CLASS} bg-petrol text-white" if @active

    "#{BASE_CLASS} text-[#C6C4BA] hover:bg-[#2A2D29] hover:text-surface"
  end

  def show_badge?
    @badge_count.to_i.positive?
  end
end
