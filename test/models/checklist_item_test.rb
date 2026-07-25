require "test_helper"

class ChecklistItemTest < ActiveSupport::TestCase
  test "vyžaduje text" do
    checklist_item = jobs(:havarie).checklist_items.new

    assert_not checklist_item.valid?
    assert_includes checklist_item.errors.attribute_names, :label
  end

  test "odškrtnutí a vrácení zpátky je tatáž akce" do
    checklist_item = checklist_items(:havarie_uzavrit)

    checklist_item.toggle_completed_by!(users(:owner))
    assert checklist_item.completed?
    assert_equal users(:owner), checklist_item.completed_by_user

    checklist_item.toggle_completed_by!(users(:owner))
    assert_not checklist_item.completed?
    assert_nil checklist_item.completed_by_user
  end
end
