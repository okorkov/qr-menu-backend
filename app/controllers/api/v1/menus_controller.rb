class Api::V1::MenusController < ApplicationController

before_action :user, except: [:demo, :demo_upload]

  def index
    render json: {status: 'success'}
  end

  def create
    menu = Menu.new(file_name_params)
    menu.user = user
    process_menu_upload(menu, menu_params[:file])
    render json: {last_file: {has_file: true, pdf_file: menu.link, qr_code: menu.qr_code_link, uploaded: menu.created_at, id: menu.id, file_name: menu.file_name}}
  end

  def demo_upload
    menu = Menu.new
    menu.user = User.find_by(email: 'demo@qr-menu.rest')
    process_menu_upload(menu, menu_params[:file])
    render json: {pdf_file: menu.link, qr_code: menu.qr_code_link, uploaded: menu.created_at}
  end

  def find_menus
    if user.menus.size > 0
      render json: {last_file: {has_file: true, pdf_file: user.menus.last.link, qr_code: user.menus.last.qr_code_link, uploaded: user.menus.last.created_at, id: user.menus.last.id, file_name: user.menus.last.file_name},
                    all_menus: user.menus
                    }
    else
      render json: {last_menu: {has_file: true, menu: nil}}
    end
  end

  def resend_qr_code
    UserMailer.send_qr_code(user).deliver_now
    render json: {status: 'success'}
  end

  def demo
    user = User.find_by(email: 'demo@qr-menu.rest')
    render json: {pdf_file: user.menus.first.link, qr_code: user.menus.first.qr_code_link, uploaded: user.menus.first.created_at}
  end

  def destroy
    if user
      if Menu.find(delete_params[:id]).destroy
        render json: {status: 'success', id: delete_params[:id]}
      else
        render json: {status: 'failed'}
      end
    else
      render json: {status: 'failed'}
    end
  end

  private 

  def menu_params
    params.permit(:token, :file)
  end

  def file_name_params
    params.permit(:file_name)
  end

  def delete_params 
    params.permit(:id, :token)
  end

end
