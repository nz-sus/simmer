class Client < ApplicationRecord
  has_many :data_sets
  has_many :log_entries, through: :data_sets
  has_many :gitleaks_results, through: :data_sets
  has_many :masked_secrets

  def to_s
    name
  end

  def report_name(report_type='leak_report')
    # This is the file name of the report that will be generated
    # Include the client name and the current date in YYYYMMDD format with underscores instead of spaces
    "SuS-#{name.underscore}_#{Time.now.strftime('%Y%m%d')}_#{report_type}"
  end

  def data_sets_with_log_entries_count
    data_sets.joins(:log_entries).distinct.count
  end

  def total_gitleaks_secrets_count
    gitleaks_results.count
  end

  def rule_id_counts
    gitleaks_results.group(:rule_id).count.sort_by { |_, count| -count }.to_h
  end

  def masked_secrets_counts
    gitleaks_results
      .group(:rule_id, :secret)
      .count
      .transform_keys { |(rule_id, secret)| "#{rule_id}: #{MaskedSecretService.mask_secret(secret)}" }
      .sort_by { |_, count| -count }
      .to_h
  end

  def suspected_leaks_count
    # fetch all of the gitleaks results that are above the 'SUSPICIOUS' severity
    gitleaks_results.above_severity('SUSPICIOUS').count
  end
end
