class ApplicationController < ActionController::API

  def welcome
    render json: {status: 200}
  end
  
end
