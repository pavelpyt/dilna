class ChecklistTemplate < ApplicationRecord
  belongs_to :account
  has_many :checklist_template_items, -> { order(:position, :id) }, dependent: :destroy

  accepts_nested_attributes_for :checklist_template_items,
                                allow_destroy: true,
                                reject_if: ->(attributes) { attributes["label"].blank? }

  validates :name, presence: true

  scope :by_name, -> { order(:name) }

  # Nakopíruje položky šablony na zakázku. Odškrtává se pak už jen kopie.
  def copy_items_to(job)
    checklist_template_items.each do |template_item|
      job.checklist_items.create!(label: template_item.label, position: template_item.position)
    end
  end
end
