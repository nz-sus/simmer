class GitleaksResult < ApplicationRecord
  after_create :assign_masked_secret

  SEARCHABLE_FIELDS = ['rule_id', 'message', 'secret', 'commit', 'severity', 'file'].freeze
  def self.elasticsearch_mappings
    {
      rule_id: { type: 'keyword' },
      message: { type: 'text' },
      secret: { type: 'text' },
      severity: { type: 'keyword' },
      file: { type: 'keyword' },
      commit: { type: 'keyword' },      
    }
  end
  include Searchable
  include Severity
  scope :above_severity, ->(severity_name) {
    severities_to_select = Severity.above_severity(severity_name)
    where(severity: severities_to_select)
  }

  scope :by_severity, ->(severity) { where(severity: severity.split(',')) if severity.present? }
  scope :by_rule_id, ->(rule_id) { where(rule_id: rule_id.split(',')) if rule_id.present? }
  scope :by_file, ->(file) { where(file: file) if file.present? }
  scope :by_commit, ->(commit) { where(commit: commit.split(',')) if commit.present? }
  scope :by_author, ->(author) { where(author: author) if author.present? }
  scope :by_email, ->(email) { where(email: email) if email.present? }
  scope :by_fingerprint, ->(fingerprint) { where(fingerprint: fingerprint) if fingerprint.present? }
  scope :by_log_entry, ->(log_entry) { where(log_entry: log_entry.split(',')) if log_entry.present? }
  scope :by_tag, ->(tag) { tagged_with(tag.split(',')) if tag.present? }



  belongs_to :log_entry
  belongs_to :masked_secret, optional: true
  belongs_to :data_set, optional: true
  has_one :client, through: :data_set
  has_and_belongs_to_many :incidents
  #has_many :notes, as: :noteable, dependent: :destroy
  has_rich_text :note
  encrypts :encrypted_secret
  def secret
    self.encrypted_secret
  end

  acts_as_taggable_on :tags
  
  def self.valid_filters
    %w[severity rule_id commit file log_entry ]
  end

  def name_for_incident
    "Gitleaks [#{self.severity.downcase}][#{self.rule_id}] #{self.file}:#{self.start_line}_#{self.start_column}"
  end
  
  def to_s
    "#{severity} #{rule_id} #{file}:#{start_line}"
  end


  def self.filter_key(name, value)
    "#{name}^#{value}"
  end
  # Some filters like data set should show a friendly name instead of the raw id
  #have rails cache the value map

  def self.filter_value_map_cache_key
    # Build the cache key from the most recent updated_at timestamp in the DataSet table
    begin      
      'GitleaksResults::filter_value_map' + DataSet.maximum(:updated_at).to_i.to_s
    rescue => exception
      'GitleaksResults::filter_value_map_empty'
    end
  end

  def self.filter_value_map
    
    Rails.cache.fetch(filter_value_map_cache_key, expires_in: 24.hours) do
      
      value_map = {}

      # For each filter that needs a friendly name, add a mapping here
      data_sets = DataSet.all.pluck(:id, :name)
      #for each data set, add the mapping to the name
      data_sets.each do |id, name|
        value_map[filter_key('data_set', id)] = name
      end

      value_map
    end
  end

  private

  def assign_masked_secret
    self.masked_secret = MaskedSecretService.assign_masked_secret!(self)
    self.save
  end 

end
