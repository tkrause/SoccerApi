class TeamMember < ApplicationRecord
  belongs_to :team
  belongs_to :user

  enum role: {
      admin: 'admin',
      coach: 'coach',
      player: 'player',
  }

  # re-format for API
  def as_json(options = {})
    {
        team_id: self.team.id,
        user_id: self.user.id,
        name: self.user.name,
        email: self.user.email,
        role: self.role,
    }
    # options[:except] ||= [:password_digest]
    # super(options)
  end
end
