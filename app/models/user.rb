class User < ApplicationRecord
  before_save :downcase_email
  has_secure_password

  has_many :team_users
  has_many :teams, through: :team_users

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

  # team methods
  def is_admin?(team)
    model = self.team_users.where(team_id: team.id).where(role: [
        :admin, :coach
    ]).first

    # if we found one, they can edit it
    ! model.nil?
  end
end
