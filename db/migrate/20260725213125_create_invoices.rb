class CreateInvoices < ActiveRecord::Migration[8.1]
  def change
    create_table :invoices do |t|
      t.references :job, null: false, foreign_key: true, index: { unique: true }
      t.string :external_id
      t.string :number, null: false
      t.string :status, null: false, default: "issued"
      t.decimal :total_with_vat, precision: 10, scale: 2, null: false, default: 0
      t.date :due_on, null: false
      t.datetime :paid_at
      t.string :pdf_url
      t.string :payment_url

      t.timestamps
    end
  end
end
