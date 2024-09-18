class AddSchemaToDataSet < ActiveRecord::Migration[7.1]
  def change
    add_column :data_sets, :schema_name, :string, null: false, default: "none"
  end
end
