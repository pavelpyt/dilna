class CreateChecklistItems < ActiveRecord::Migration[8.1]
  def change
    create_table :checklist_items do |t|
      t.references :job, null: false, foreign_key: true
      t.references :completed_by_user, foreign_key: { to_table: :users }
      t.string :label, null: false
      t.integer :position, null: false, default: 0
      t.datetime :completed_at

      t.timestamps
    end
  end
end
