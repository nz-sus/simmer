class CreateDataSets < ActiveRecord::Migration[7.1]
  def change
    create_table :data_sets, id: :uuid do |t|
      t.string :name
      t.datetime :time_range_start
      t.datetime :time_range_end
      t.references :client, null: false, foreign_key: true, type: :uuid
      t.text :description

      t.timestamps
    end
  end
end
