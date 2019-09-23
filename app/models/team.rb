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

  def compute_wins_losses
    # get only game events
    events = self.events.where(event_type: 'game')
    stats = events.reduce({ wins: 0, losses: 0 }) do |acc, e|
      # ignore future and in-progress games
      next acc unless e.is_ended?

      # determine our score and other team score
      if e.home_team_id == self.id
        my_score = e.home_score
        other_score = e.away_score
      else
        my_score = e.away_score
        other_score = e.home_score
      end

      # determine win or loss
      if my_score >= other_score
        acc[:wins] += 1
      else
        acc[:losses] += 1
      end

      acc
    end

    # save the computed values
    self.wins = stats[:wins]
    self.losses = stats[:losses]

    # update without changing timestamps
    self.save!(touch: false)
  end
end
