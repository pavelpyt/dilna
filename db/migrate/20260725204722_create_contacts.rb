class CreateContacts < ActiveRecord::Migration[8.1]
  def change
    create_table :contacts do |t|
      t.references :client, null: false, foreign_key: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :position
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
