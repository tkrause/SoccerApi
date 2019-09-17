class TeamMembersController < ApplicationController
  # protect update and delete from modifications
  # by non admins
  before_action :set_team
  before_action :set_member, only: [:show, :update, :destroy]
  before_action :admin_or_fail, only: [:create, :destroy, :update]

  # GET /teams/:team_id/members
  def index
    # get members for this team
    # @teams = @current_user.teams
    # @members = TeamMember.includes(:user).where(:team_id => params[:team_id])
    @members = @team.team_members.includes(:user)

    render json: @members
  end

  # POST /teams/:team_id/members
  def create
    # add member to team
    @member = TeamMember.create! team_member_params

    render json: @team.team_members.includes(:user), status: :created
  end

  # GET /teams/:team_id/members/:id
  def show
    render json: @member
  end

  # PATCH(PUT) /teams/:team_id/members/:id
  def update
    if @member.update(team_member_params)
      render json: @member
    else
      render json: @member.errors, status: :unprocessable_entity
    end
  end

  # DELETE /teams/:team_id/members/:id
  def destroy
    # remove member from team
    @member.delete

    head :no_content
  end

  private

  def admin_or_fail
    raise Errors::Forbidden unless @current_user.is_admin? @team
  end

  def set_team
    @team = Team.find params[:team_id]
  end

  def set_member
    @member = TeamMember.includes(:user).find params[:id]
  end

  def team_member_params
    params.permit(:user_id, :role, :jersey_number).merge(team_id: @team.id)
  end
end
