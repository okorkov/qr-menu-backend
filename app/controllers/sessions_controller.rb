class SessionsController < ApplicationController

  def create

    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      
      token = Auth.create_token({user: user, menus: user.menus})
      render json: {token: token, logged_in: true}, status: 200
			
    else
      render json: {errors: "Email or Password is incorrect"}, status: 200
    end
  end

  def is_logged_in?

    decoded = Auth.decode_token(params[:token])
    if User.find_by(email: decoded.first['user']['user']['email'])
      render json: {logged_in: true, status: 'success'}
    elsif
      render json: {logged_in: false, status: 'success'}
    end
    
  end

end