class CreateJobItems < ActiveRecord::Migration[8.1]
  def change
    create_table :job_items do |t|
      t.references :job, null: false, foreign_key: true
      t.references :service, foreign_key: true
      t.string :description, null: false
      t.decimal :quantity, precision: 10, scale: 2, null: false, default: 1
      t.string :unit, null: false, default: "ks"
      t.decimal :unit_price, precision: 10, scale: 2, null: false, default: 0
      t.integer :vat_rate, null: false, default: 21
      t.integer :position, null: false, default: 0

      t.timestamps
    end
  end
end
