class CreateSmsMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :sms_messages do |t|
      t.references :client, null: false, foreign_key: true
      t.references :job, foreign_key: true
      t.text :body, null: false
      t.string :status, null: false, default: "queued"
      t.string :template_name
      t.string :external_id
      t.datetime :sent_at

      t.timestamps
    end
  end
end
