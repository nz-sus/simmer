class LogEntry < ApplicationRecord
  belongs_to :data_set, optional: true
  has_one :client, through: :data_set
  has_one :gitleaks_result, dependent: :destroy

  after_create :create_result_from_log_entry

  #add a scope called critical that selects the log entries that have a gitleaks_result with a severity of critical
  scope :critical, -> { joins(:gitleaks_result).where(gitleaks_result: { severity: 'CRITICAL' }) }

  def create_result_from_log_entry
    # Create a new specific result for each object based on the template
    case data_schema
    when 'gitleaks'
      GitleaksResultService.create_from_log_entry(self)
    else
      # Do nothing
      Rails.logger.warn("Unknown schema name: #{data_schema||'no schema'}")
    end
  end
  
  def to_s
    title
  end
end
