class CreateServiceTokens < ActiveRecord::Migration[7.1]
  def change
    #alter table users id set data type to uuid    
    create_table :service_tokens, id: :uuid do |t|
      t.string :token
      t.references :user, null: false, foreign_key: true
      t.string :permission
      t.datetime :expires_at

      t.timestamps
    end
  end
end
