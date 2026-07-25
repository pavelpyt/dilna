require "test_helper"

class ChecklistItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:owner)
  end

  test "odškrtne položku checklistu" do
    patch job_checklist_item_path(jobs(:havarie), checklist_items(:havarie_uzavrit))

    assert checklist_items(:havarie_uzavrit).reload.completed?
  end

  test "přidá checklist ze šablony" do
    assert_difference "ChecklistItem.count", 2 do
      post job_job_checklists_path(jobs(:baterie)), params: { checklist_template_id: checklist_templates(:havarie_voda).id }
    end
  end
end
