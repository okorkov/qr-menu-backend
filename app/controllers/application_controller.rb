class ApplicationController < ActionController::API

  def welcome
    render json: {status: 200, database: ENV['RDS_USERNAME']}
  end
end
