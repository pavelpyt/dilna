class CreateJobPhotos < ActiveRecord::Migration[8.1]
  def change
    create_table :job_photos do |t|
      t.references :job, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :caption

      t.timestamps
    end
  end
end
