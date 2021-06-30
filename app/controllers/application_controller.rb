class ApplicationController < ActionController::API

  

  def welcome
    render json: {status: 200, health: 'ok'}
  end

end
