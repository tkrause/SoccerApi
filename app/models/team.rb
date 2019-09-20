class Team < ApplicationRecord
  has_many :team_members
  has_many :users, through: :team_members, dependent: :destroy

  alias_attribute :members, :users

  def events
    Event.where('home_team_id = ? OR away_team_id = ?', self.id, self.id)
  end
end
