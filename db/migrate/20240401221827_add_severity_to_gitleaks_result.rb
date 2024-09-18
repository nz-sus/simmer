class AddSeverityToGitleaksResult < ActiveRecord::Migration[7.1]
  def change
    add_column :gitleaks_results, :severity, :string, null: false, default: 'UNKNOWN'
  end
end
