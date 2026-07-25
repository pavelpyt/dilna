class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.references :invoice, null: false, foreign_key: true
      t.string :external_id
      t.decimal :amount, precision: 10, scale: 2, null: false, default: 0
      t.string :status, null: false, default: "pending"
      t.datetime :paid_at

      t.timestamps
    end
  end
end
