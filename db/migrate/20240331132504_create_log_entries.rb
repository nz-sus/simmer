class CreateLogEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :log_entries, id: :uuid do |t|
      t.string :title
      t.string :data_schema
      t.datetime :timestamp
      t.text :data_json
      t.references :data_set, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
