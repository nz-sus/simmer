class CreateMaskedSecrets < ActiveRecord::Migration[7.1]
  def change
    create_table :masked_secrets, id: :uuid do |t|      
      t.integer :count
      t.text :notes
      t.string :secret
      t.string :secret_hash
      t.references :client, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
    
    # Add a foreign key to the gitleaks_results table
    add_reference :gitleaks_results, :masked_secret, type: :uuid, foreign_key: true    

  end
end
