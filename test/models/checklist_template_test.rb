require "test_helper"

class ChecklistTemplateTest < ActiveSupport::TestCase
  test "vyžaduje název" do
    checklist_template = accounts(:novak).checklist_templates.new

    assert_not checklist_template.valid?
    assert_includes checklist_template.errors.attribute_names, :name
  end

  test "nakopíruje položky na zakázku" do
    job = jobs(:baterie)

    assert_difference "ChecklistItem.count", 2 do
      checklist_templates(:havarie_voda).copy_items_to(job)
    end

    assert_equal "Uzavřít přívod vody", job.checklist_items.in_order.first.label
  end
end
