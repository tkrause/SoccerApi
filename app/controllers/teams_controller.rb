class TeamsController < ApplicationController
  # protect update and delete from modifications
  # by non admins
  before_action :set_team, only: [:show, :update, :destroy]
  before_action :admin_or_fail, only: [:update, :destroy]

  # GET /teams
  def index
    # get only teams that this user can see
    @teams = @current_user.teams

    render json: @teams
  end

  # GET /teams/all
  def all
    # get all teams
    @teams = Team.all

    render json: @teams
  end

  # GET /teams/:id
  def show
    # we won't filter here since all teams
    # will be visible by everyone
    render json: @team
  end

  # POST /teams
  def create
    # anyone can create a team
    @team = Team.create!(team_params)
    @team.add_creator_as_admin(@current_user)

    render json: @team, status: :created
  end

  # PATCH/PUT /teams/:id
  def update
    if @team.update(team_params)
      render json: @team
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  # DELETE /teams/:id
  def destroy
    # ensure user is an admin or coach
    # this is already handled
    @team.destroy
    head :no_content
  end

  private
    def admin_or_fail
      raise Errors::Forbidden unless @current_user.is_admin? @team
    end

    def set_team
      @team = Team.find params[:id]
    end

    def team_params
      params.permit(:name, :team_number)
    end
end
