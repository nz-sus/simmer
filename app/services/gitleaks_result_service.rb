class GitleaksResultService
  def self.create_from_log_entry(log_entry)
    data = JSON.parse(log_entry.data_json)
    
    GitleaksResult.create(
      log_entry: log_entry,
      data_set: log_entry.data_set,
      description: data["Description"],
      start_line: data["StartLine"]&.to_i,
      end_line: data["EndLine"]&.to_i,
      start_column: data["StartColumn"]&.to_i,
      end_column: data["EndColumn"]&.to_i,
      match: data["Match"],
      secret: data["Secret"],
      file: data["File"],
      symlink_file: data["SymlinkFile"],
      commit: data["Commit"],
      entropy: data["Entropy"].to_f,
      author: data["Author"],
      email: data["Email"],
      date: data["Date"],
      message: data["Message"],
      gltags: data["Tags"],
      rule_id: data["RuleID"],
      fingerprint: data["Fingerprint"]
    )
  end
  def self.severity_list
    %w[CRITICAL HIGH MEDIUM LOW SUSPICIOUS SAFE UNKNOWN]
  end
end
