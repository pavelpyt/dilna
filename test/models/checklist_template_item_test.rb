require "test_helper"

class ChecklistTemplateItemTest < ActiveSupport::TestCase
  test "vyžaduje text" do
    template_item = checklist_templates(:havarie_voda).checklist_template_items.new

    assert_not template_item.valid?
    assert_includes template_item.errors.attribute_names, :label
  end
end
