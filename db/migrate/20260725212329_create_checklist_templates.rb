class CreateChecklistTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :checklist_templates do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
