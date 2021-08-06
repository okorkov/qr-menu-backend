class ApplicationController < ActionController::API

  include ActiveStorage::SetCurrent
  include MenusHelper

  def welcome
    render json: {status: 200, health: 'ok'}
  end

end
