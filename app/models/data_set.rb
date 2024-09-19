class DataSet < ApplicationRecord
  belongs_to :client, optional: true
  has_many :log_entries, dependent: :destroy
  has_many :gitleaks_results, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :client_id }

  def self.available_schema_names
    # Get all the data schemas for the client
    %w[none gitleaks trufflehog trivy]
  end

  def repository_type
    # Determine the repository type based on the source_url, check that it starts with https://gitlab.com/ or https://github.com/ 
    return 'gitlab' if source_url&.start_with?('https://gitlab.com/')
    return 'github' if source_url&.start_with?('https://github.com/')
      
    'unknown'
  end

  def to_s
    name
  end
end
