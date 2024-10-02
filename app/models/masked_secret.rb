class MaskedSecret < ApplicationRecord
  belongs_to :client
  has_many :gitleaks_results
  #has_one :note, as: :noteable, dependent: :destroy
  has_rich_text :note

  after_update :update_gitleaks_results

  include Severity

  scope :above_severity, ->(severity_name) {
    severities_to_select = Severity.above_severity(severity_name)
    where(severity: severities_to_select)
  }

  scope :by_count, -> { order(count: :desc) }
  scope :by_severity_then_count, -> {
    order(Arel.sql("CASE severity 
                     WHEN 'CRITICAL' THEN 0 
                     WHEN 'HIGH' THEN 1 
                     WHEN 'MEDIUM' THEN 2 
                     WHEN 'LOW' THEN 3 
                     WHEN 'SUSPICIOUS' THEN 4 
                     WHEN 'UNKNOWN' THEN 5 
                     WHEN 'SAFE' THEN 6 
                    END, count DESC"))
  }

  def to_s
    secret
  end

  def unmasked_secret
    logger.info "Unmasking secret: #{secret} for masked secret: #{id}"
    #Introduce additional checks here to ensure the secret is only unmasked in a secure context?
    gitleaks_results.first.secret
  end

  private

  def update_gitleaks_results
    gitleaks_results.update_all(severity: severity)
  end

end
