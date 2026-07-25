class CreatePublicTokens < ActiveRecord::Migration[8.1]
  def change
    create_table :public_tokens do |t|
      t.references :job, null: false, foreign_key: true
      t.string :token, null: false
      t.datetime :expires_at

      t.timestamps
    end

    add_index :public_tokens, :token, unique: true
  end
end
