class TestController < ApplicationController

  def test
    render json: @current_user
  end

end
