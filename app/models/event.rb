class Event < ApplicationRecord
  record_timestamps = false

  belongs_to :home_team, class_name: 'Team'
  belongs_to :away_team, class_name: 'Team', optional: true

  after_save :compute_team_wins_losses

  validate :validate_teams_are_different

  enum event_type: {
      game: 'game',
      event: 'event',
  }

  default_scope { order(:start_at) }

  scope :game, -> { where(event_type: 'game') }
  scope :not_game, -> { where.not(event_type: 'game') }
  scope :future, -> { where('start_at > ?', DateTime.now) }

  def self.for_teams(teams)
    Event.where(away_team_id: teams).or(
        Event.where(home_team_id: teams)
    )
  end

  def is_ended?
    self.ended_at&.present? and self.ended_at&.past?
  end

  def compute_team_wins_losses
    self.home_team&.compute_wins_losses
    self.away_team&.compute_wins_losses
  end

  def validate_teams_are_different
    if home_team_id.nil?
      errors.add(:home_team, "Home team can't be blank")
    end

    return unless home_team_id.present? and away_team_id.present?

    if home_team_id == away_team_id
      errors.add(:away_team, "Away team can't be the same as home team")
    end
  end
end
