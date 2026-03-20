class User < ApplicationRecord
  has_secure_password

  enum :role, { runner: 0, organizer: 1, admin: 2 }

  before_validation :normalize_email

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :role, presence: true
  validates :password, length: { minimum: 8 }

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
