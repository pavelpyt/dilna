class CreateQuotes < ActiveRecord::Migration[8.1]
  def change
    create_table :quotes do |t|
      t.references :job, null: false, foreign_key: true
      t.string :status, null: false, default: "draft"
      t.date :valid_until
      t.datetime :sent_at
      t.datetime :decided_at

      t.timestamps
    end
  end
end
