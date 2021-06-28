class ApplicationController < ActionController::API

  def welcome
    user = User.all.first
    render json: {status: 200, database: ENV['RDS_USERNAME'], user: user}
  end
end
