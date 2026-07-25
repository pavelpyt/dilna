class CreateServices < ActiveRecord::Migration[8.1]
  def change
    create_table :services do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name, null: false
      t.string :unit, null: false, default: "ks"
      t.decimal :unit_price, precision: 10, scale: 2, null: false, default: 0
      t.integer :vat_rate, null: false, default: 21
      t.integer :margin_percent
      t.boolean :archived, null: false, default: false

      t.timestamps
    end
  end
end
