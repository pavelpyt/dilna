class ChecklistTemplateItem < ApplicationRecord
  belongs_to :checklist_template

  validates :label, presence: true
end
