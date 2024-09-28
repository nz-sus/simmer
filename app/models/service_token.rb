class ServiceToken < ApplicationRecord
  belongs_to :user
  belongs_to :client

  before_create :generate_token

  validates :token, uniqueness: true
  validates :user, presence: true
  validates :client, presence: true
  validates :permission, presence: true, inclusion: { in: %w[read_only write_only read_write] }

  scope :valid, -> { where('expires_at IS NULL OR expires_at > ?', Time.current) }

  def generate_token
    self.token = SecureRandom.hex(20)
  end

  def expired?
    expires_at.present? && expires_at < Time.current
  end

  # Check if the token is read-only
  def read_only?
    permission == 'read_only'
  end

  # Check if the token is write-only
  def write_only?
    permission == 'write_only'
  end

  # Check if the token has full access (read and write)
  def full_access?
    permission == 'read_write'
  end
end
