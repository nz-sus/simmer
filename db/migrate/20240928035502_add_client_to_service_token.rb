class AddClientToServiceToken < ActiveRecord::Migration[7.1]
  def change
    # remove existing service_tokens
    ServiceToken.delete_all
    add_reference :service_tokens, :client, null: false, foreign_key: true, type: :uuid
  end
end
