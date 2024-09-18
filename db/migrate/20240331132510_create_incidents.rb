class CreateIncidents < ActiveRecord::Migration[7.1]
  def change
    create_table :incidents, id: :uuid do |t|
      t.string :name
      t.datetime :opened_at
      t.datetime :closed_at
      t.references :client, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
