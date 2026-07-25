class CreateChecklistTemplateItems < ActiveRecord::Migration[8.1]
  def change
    create_table :checklist_template_items do |t|
      t.references :checklist_template, null: false, foreign_key: true
      t.string :label, null: false
      t.integer :position, null: false, default: 0

      t.timestamps
    end
  end
end
