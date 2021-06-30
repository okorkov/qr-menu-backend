class UsersController < ApplicationController

  def create

    # user = User.find_by(email: params[:email])

    # if user && user.authenticate(params[:password])
      
    #   token = Auth.create_token(user)
    #   returned_user = Auth.decode_token(token)
    #   render json: {token: token, logged_in: true}, status: 200
			
    # else
    #   render json: {errors: "Email or Password is incorrect"}, status: 500
    # end

    user = User.new(user_params)

    if user.save
      token = Auth.create_token({user: user, menus: user.menus})
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