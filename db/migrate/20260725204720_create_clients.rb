class CreateClients < ActiveRecord::Migration[8.1]
  def change
    create_table :clients do |t|
      t.references :account, null: false, foreign_key: true
      t.string :client_type, null: false, default: "company"
      t.string :name, null: false
      t.string :company_registration_number
      t.string :vat_identification_number
      t.string :email
      t.string :phone
      t.text :note

      t.timestamps
    end
  end
end
