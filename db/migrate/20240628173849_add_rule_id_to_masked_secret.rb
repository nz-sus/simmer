class AdRuleIdToMaskedSecret < ActiveRecord::Migration[7.1]
  def change
    add_column :masked_secrets, :rule_id, :string
  end
end
