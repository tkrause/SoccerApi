class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'unauthorized' }, status: 401 unless @current_user
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: e.message }, status: 404
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { error: e.message }, status: 422
  end

  rescue_from ActiveRecord::RecordNotUnique do |_|
    render json: { error: 'non unique entity' }, status: 409
  end

  rescue_from Errors::Forbidden do |_|
    render json: { error: 'you do not have access to modify this resource' }, status: :forbidden
  end

end
