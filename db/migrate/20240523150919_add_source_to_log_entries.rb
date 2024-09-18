class AddSourceToLogEntries < ActiveRecord::Migration[7.1]
  def change
    add_column :log_entries, :source, :string, default: "", null: false    
  end
end
