class AddSeverityToMaskedSecrets < ActiveRecord::Migration[7.1]
  def change
    add_column :masked_secrets, :severity, :string, null: false, default: 'UNKNOWN'
  end
end
