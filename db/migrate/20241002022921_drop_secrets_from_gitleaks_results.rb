class DropSecretsFromGitleaksResults < ActiveRecord::Migration[7.1]
  def change
    remove_column :gitleaks_results, :secret
  end  
end
