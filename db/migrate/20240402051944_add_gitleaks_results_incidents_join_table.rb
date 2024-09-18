class AddGitleaksResultsIncidentsJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_table :gitleaks_results_incidents, id: false do |t|
      t.belongs_to :gitleaks_result, null: false, foreign_key: true, type: :uuid
      t.belongs_to :incident, null: false, foreign_key: true, type: :uuid
    end

    # Optional: Add an index for faster querying through the association
    add_index :gitleaks_results_incidents, [:gitleaks_result_id, :incident_id], unique: true, name: 'index_gitleaks_results_incidents_on_both_ids'
  end
end
