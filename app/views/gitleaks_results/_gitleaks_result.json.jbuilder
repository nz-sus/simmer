json.extract! gitleaks_result, :id, :description, :start_line, :end_line, :start_column, :end_column, :match, :secret, :file, :symlink_file, :commit, :entropy, :author, :email, :date, :message, :gltags, :rule_id, :fingerprint, :log_entry_id, :created_at, :updated_at
json.url gitleaks_result_url(gitleaks_result, format: :json)
