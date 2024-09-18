class RemoveNullConstraints < ActiveRecord::Migration[7.1]
  def change
    # remove_null_constraint  from all of the optional belongs_tos
    change_column_null :incidents, :client_id, true
    change_column_null :data_sets, :client_id, true
    change_column_null :log_entries, :data_set_id, true
  end
end
