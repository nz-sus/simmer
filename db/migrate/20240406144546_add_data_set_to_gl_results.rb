class AddDataSetToGlResults < ActiveRecord::Migration[7.1]
  def change
    #Type is uuid
    add_column :gitleaks_results, :data_set_id, :uuid
  end
end
