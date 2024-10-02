class CopySecretsToEncrypted < ActiveRecord::Migration[7.1]
  def up
    GitleaksResult.all.each do |result|
      result.encrypted_secret = result.secret
      result.save
    end
  end
  def down
  end
end
