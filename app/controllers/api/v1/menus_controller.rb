class Api::V1::MenusController < ApplicationController

before_action :user, except: [:demo, :demo_upload]

  def index
    render json: {status: 'success'}
  end

  def create
    menu = Menu.new
    menu.user = user
    menu.pdf_file.attach(menu_params['file'])
    menu.link = menu.pdf_file.url.sub(/\?.*/, '')
    qrcode = RQRCode::QRCode.new(menu.link)
    png = qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: "black",
      file: nil,
      fill: "white",
      module_px_size: 8,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 400
    )
    menu.qr_code.attach(io: StringIO.new(png.to_s), filename: "qr_code_#{menu.id}.png")
    menu.qr_code_link = menu.qr_code.url.sub(/\?.*/, '')
    menu.save
    UserMailer.send_qr_code(user).deliver_now
    render json: {pdf_file: menu.link, qr_code: menu.qr_code_link, uploaded: menu.created_at}
  end

  def find_menus
    if user.menus.size > 0
      render json: {last_menu: {has_menu: true, pdf_file: user.menus.last.link, qr_code: user.menus.last.qr_code_link, uploaded: user.menus.last.created_at}}
    else
      render json: {last_menu: {menu: false}}
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

  def demo_upload
    menu = Menu.new
    menu.user = User.find_by(email: 'demo@qr-menu.rest')
    menu.pdf_file.attach(menu_params['file'])
    menu.link = menu.pdf_file.url.sub(/\?.*/, '')
    qrcode = RQRCode::QRCode.new(menu.link)
    png = qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: "black",
      file: nil,
      fill: "white",
      module_px_size: 8,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 400
    )
    menu.qr_code.attach(io: StringIO.new(png.to_s), filename: "qr_code_#{menu.id}.png")
    menu.qr_code_link = menu.qr_code.url.sub(/\?.*/, '')
    menu.save
    render json: {pdf_file: menu.link, qr_code: menu.qr_code_link, uploaded: menu.created_at}
  end

  private 

  def menu_params
    params.permit(:token, :file)
  end

end
