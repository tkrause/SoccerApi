class TeamMember < ApplicationRecord
  belongs_to :team
  belongs_to :user

  enum role: {
      admin: 'admin',
      coach: 'coach',
      player: 'player',
  }

  def as_json(options = {})
    super(options).merge({ user: self.user.as_json })
  end

end
