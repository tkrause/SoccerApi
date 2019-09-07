class User < ApplicationRecord

  before_save :downcase_email
  has_secure_password

  # validations
  validates_presence_of :email
  validates_uniqueness_of :email, case_sensitive: false

  # lowercase all emails
  def downcase_email
    self.email = self.email.delete(' ').downcase
  end

  # hide sensitive data
  def to_json(options = {})
    options[:except] ||= [:password_digest]
    super(options)
  end

end
