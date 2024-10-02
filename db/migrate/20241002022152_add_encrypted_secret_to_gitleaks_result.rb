class AddEncryptedSecretToGitleaksResult < ActiveRecord::Migration[7.1]
  def change
    add_column :gitleaks_results, :encrypted_secret, :text
  end
end
