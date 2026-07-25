class CreateVisits < ActiveRecord::Migration[8.1]
  def change
    # btree_gist umožní kombinovat rovnost na user_id s překryvem časového rozsahu.
    enable_extension "btree_gist"

    create_table :visits do |t|
      t.references :job, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.column :starts_at, :timestamptz, null: false
      t.column :ends_at, :timestamptz, null: false
      t.string :status, null: false, default: "planned"
      t.text :note

      t.timestamps
    end

    add_index :visits, :starts_at

    # Dva překrývající se termíny u jednoho technika odmítne rovnou databáze.
    # Samotná kontrola v modelu by při souběžném ukládání mohla proklouznout.
    reversible do |direction|
      direction.up do
        execute <<~SQL
          ALTER TABLE visits
          ADD CONSTRAINT visits_do_not_overlap_for_one_technician
          EXCLUDE USING gist (
            user_id WITH =,
            tstzrange(starts_at, ends_at) WITH &&
          )
        SQL
      end

      direction.down do
        execute "ALTER TABLE visits DROP CONSTRAINT visits_do_not_overlap_for_one_technician"
      end
    end
  end
end
