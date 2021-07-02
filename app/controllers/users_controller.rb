class UsersController < ApplicationController

  def create
    user = User.new(user_params)

    if user.save
      UserMailer.welcome_email(user).deliver_now
      token = Auth.create_token(user)
      render json: {token: token, logged_in: true}, status: 200
			
    else
      render json: {errors: user.errors, logged_in: false, status: 500}, status: 200
    end

  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

end