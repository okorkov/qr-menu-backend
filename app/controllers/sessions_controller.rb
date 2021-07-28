class SessionsController < ApplicationController

  before_action :user, except: [:create, :google_auth]

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      token = Auth.create_token(user)
      render json: user_json(user, token)
    else
      render json: {errors: "Email or Password is incorrect"}
    end
  end

  def is_logged_in?
    if user
      render json: user_json(user)
    elsif
      render json: {logged_in: false, status: 'success'}
    end
  end

  def google_auth
    user = User.find_or_create_by(google_params)
    if user.password.nil? user.password = SecureRandom.hex(10)
    user.save
    if user
      token = Auth.create_token(user)
      render json: user_json(user, token)
    else
      render json: {errors: "failed oauth"}
    end
  end

  private

  def google_params
    params.permit(:email)
  end

  def menu_params
    params.permit(:token)
  end

end