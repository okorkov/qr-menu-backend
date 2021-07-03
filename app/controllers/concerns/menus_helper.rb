module MenusHelper

  def user
    decoded = Auth.decode_token(menu_params[:token])
    user = User.find_by(id: decoded.first['user']['id'])
  end

end