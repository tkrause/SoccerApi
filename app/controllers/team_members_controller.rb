class TeamMembersController < ApplicationController
  # protect update and delete from modifications
  # by non admins
  before_action :set_team
  before_action :admin_or_fail

  # GET /teams/:id/members
  def index
    # get members for this team
    # @teams = @current_user.teams
    @members = @team.members

    render json: @members
  end

  # POST /teams/:id/members
  def create
    # add member to team
    @member = TeamMember.create! team_member_params

    render json: @team.members
  end

  private

  def admin_or_fail
    raise Errors::Forbidden unless @current_user.is_admin? @team
  end

  def set_team
    @team = Team.find params[:team_id]
  end

  def team_member_params
    params.permit(:user_id, :role).merge(team_id: @team.id)
  end
end
