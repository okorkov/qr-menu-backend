class Api::V1::MenusController < ApplicationController

  def index
    render json: {status: 'success'}
  end

  def create
    decoded = Auth.decode_token(menu_params['token'])
    user_id_decoded = decoded.first['user']['user']['id']
    user = User.find_by(id: user_id_decoded)
    menu = Menu.new
    menu.user = user
    menu.pdf_file.attach(menu_params['file'])
    menu.save
    debugger
    render json: {menu: menu, menu_doc: menu.pdf_file, link: menu.pdf_file}
  end

  def find_menus
    decoded = Auth.decode_token(params[:token])
    user_id_decoded = decoded.first['user']['user']['id']
    user = User.find_by(id: user_id_decoded)
    if user.menus.size > 0
      render json: {last_menu: {menu: user.menus.last, pdf_file: user.menus.last.pdf_file}}
    else
      render json: {last_menu: {menu: nil, pdf_file: nil}}
    end
  end

  private 

  def menu_params
    params.permit(:token, :file)
  end

end
