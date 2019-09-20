class EventsController < ApplicationController
  # protect update and delete from modifications
  # by non admins
  before_action :set_event_type, only: [:create]
  before_action :set_teams, only: [:create]
  before_action :admin_or_fail, only: [:create]

  def index
    # list only events for teams the user is in
    teams = @current_user.teams.pluck(:id)
    render json: Event.for_teams(teams)
  end

  def for_team
    @team = Team.find params[:team_id]
    render json: @team.events
  end

  def create

  end

  private

  def admin_or_fail
    raise Errors::Forbidden unless @current_user.is_admin? @team
  end

  def set_teams
    @home_team = Team.find params[:home_team_id]
    @away_team = Team.find_by(id: params[:away_team_id]) if @is_game
  end

  def set_event_type
    @is_game = (params.has_key?(:event_type) and params[:event_type] == 'game')
  end

  def team_params
    # always allowed for both types
    allowed = [:event_type, :home_team_id, :location_name, :location_address, :location_detail, :start_at]
    if @is_game
      allowed = allowed + [:away_team_id, :home_score, :away_score, :started_at, :ended_at]
    end

    params.permit(allowed)
  end
end