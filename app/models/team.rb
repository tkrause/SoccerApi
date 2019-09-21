class Team < ApplicationRecord
  has_many :team_members
  has_many :users, through: :team_members, dependent: :destroy

  has_many :events, ->(team) do
    unscope(:where).where("home_team_id = :id OR away_team_id = :id", id: team.id)
  end

  alias_attribute :members, :users
  #
  # def events
  #   Event.where('home_team_id = ? OR away_team_id = ?', self.id, self.id)
  # end

  def add_creator_as_admin(creator)
    TeamMember.create(user: creator, team: self, role: 'admin')
  end
end
