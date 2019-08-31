class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request
  before_action :authenticate_request, only: [:user]

  def authenticate
    command = AuthenticateUser.call(params[:email], params[:password])

    if command.success?
      render json: command.result
    else
      render json: {error: command.errors}, status: :unauthorized
    end
  end

  def user
    render json: @current_user
  end
end
