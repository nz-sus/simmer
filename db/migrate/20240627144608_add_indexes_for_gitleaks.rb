class AddIndexesForGitleaks < ActiveRecord::Migration[7.1]
  def change
    add_index :gitleaks_results, :severity    
  end
end
