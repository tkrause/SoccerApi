class TeamMember < ApplicationRecord
  belongs_to :team
  belongs_to :user

  enum role: {
      admin: 'admin',
      coach: 'coach',
      player: 'player',
  }
end
