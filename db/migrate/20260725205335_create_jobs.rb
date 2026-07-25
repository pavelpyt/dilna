class CreateJobs < ActiveRecord::Migration[8.1]
  def change
    create_table :jobs do |t|
      t.references :account, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.references :property, foreign_key: true
      t.string :number, null: false
      t.string :title, null: false
      t.text :description
      t.string :status, null: false, default: "inquiry"
      t.datetime :scheduled_start_at
      t.datetime :scheduled_end_at

      t.timestamps
    end

    add_index :jobs, [ :account_id, :number ], unique: true
    add_index :jobs, [ :account_id, :status ]
  end
end
