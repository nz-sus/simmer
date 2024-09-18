class AddSourceUrlToDataSet < ActiveRecord::Migration[7.1]
  def change
    add_column :data_sets, :source_url, :string
  end
end
