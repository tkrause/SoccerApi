class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

  def current_user
    render json: @current_user
  end

  def create
    user = User.create! user_params
    render json: user, status: :created
  end

  def invite
    user = User.create! user_invite_params
    render json: user, status: :created
  end

  def search
    query = User.select '*'

    search_params.each do |key, value|
      query = query.where("#{key} LIKE ?", "#{value}%")
    end

    render json: query
  end

  private

  def search_params
    params.permit :email
  end

  def user_params
    params.permit :name, :email, :password, :password_confirmation
  end

  def user_invite_params
    params.permit(:name, :email).merge(password: "Welcome#{Date.current.year}")
  end

  def set_user
    @user = User.find params[:id]
  end

end
