class CreateProperties < ActiveRecord::Migration[8.1]
  def change
    create_table :properties do |t|
      t.references :client, null: false, foreign_key: true
      t.string :label
      t.string :street, null: false
      t.string :city, null: false
      t.string :postal_code
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.text :note

      t.timestamps
    end
  end
end
