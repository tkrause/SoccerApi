class EventsController < ApplicationController
  # protect update and delete from modifications
  # by non admins
  before_action :set_event_type, only: [:create]
  before_action :set_event, only: [:show, :update, :destroy]
  before_action :set_teams_create, only: [:create]
  before_action :set_teams, only: [:update, :destroy]
  before_action :admin_or_fail, only: [:create, :update, :destroy]

  def index
    # list only events for teams the user is in
    teams = @current_user.teams.pluck(:id)
    render json: Event.for_teams(teams), include: [:away_team, :home_team]
  end

  def for_team
    @team = Team.find(params[:team_id])
    render json: @team.events.includes(:away_team, :home_team), include: [:away_team, :home_team]
  end

  def create
    @event = Event.create! event_params
    render json: @event, status: :created
  end

  def show
    render json: @event
  end

  def update
    if @event.update(event_params)
      render json: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
    end

  def destroy
    is_future = @event.start_at.future?
    is_ended = @event.is_ended?

    # only allow destroy if the event hasn't occurred
    if is_future or is_ended
      @event.destroy
      head :no_content
    else
      render json: { errors: 'cannot delete an event or game that has already occurred' }, status: :bad_request
    end
  end

  def recent_game
    @team = Team.find(params[:team_id])
    @recent = @team.events.unscoped.where(
        'start_at <= ?', DateTime.now
    ).where(event_type: 'game').order('start_at DESC').first

    render json: @recent
  end

  def next_event
    @team = Team.find(params[:team_id])
    @next = @team.events.where(
        'start_at > ?', DateTime.now
    ).first

    render json: @next
  end

  private

  def admin_or_fail
    is_admin = @current_user.is_admin?(@home_team) or @current_user.is_admin?(@away_team)
    raise Errors::Forbidden unless is_admin
  end

  def set_teams_create
    @home_team = Team.find params[:home_team_id]
    @away_team = Team.find_by(id: params[:away_team_id]) if @is_game
  end

  def set_teams
    @home_team = @event.home_team
    @away_team = @event.away_team
  end

  def set_event_type
    @is_game = (params.has_key?(:event_type) and params[:event_type] == 'game')
  end

  def set_event
    @event = Event.find params[:id]
  end

  def event_params
    # always allowed for both types
    allowed = [:event_type, :home_team_id, :location_name, :location_address, :location_detail, :start_at]
    if @is_game
      allowed = allowed + [:away_team_id, :home_score, :away_score, :started_at, :ended_at]
    end

    params.permit(allowed)
  end
end