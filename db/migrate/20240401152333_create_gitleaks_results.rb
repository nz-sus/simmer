class CreateGitleaksResults < ActiveRecord::Migration[7.1]
  def change
    create_table :gitleaks_results, id: :uuid do |t|
      t.string :description
      t.integer :start_line
      t.integer :end_line
      t.integer :start_column
      t.integer :end_column
      t.string :match
      t.string :secret
      t.string :file
      t.string :symlink_file
      t.string :commit
      t.float :entropy
      t.string :author
      t.string :email
      t.datetime :date
      t.text :message
      t.text :tags
      t.string :rule_id
      t.string :fingerprint
      t.references :log_entry, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
