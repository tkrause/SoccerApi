class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

  def current_user
    render json: @current_user
  end

  def create
    user = User.create! user_params
    render json: user, status: :created
  end

  private

  def user_params
    params.permit :name, :email, :password, :password_confirmation
  end

  def set_user
    @user = User.find params[:id]
  end

end
