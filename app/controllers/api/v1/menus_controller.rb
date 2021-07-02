class Api::V1::MenusController < ApplicationController

  def index
    render json: {status: 'success'}
  end

  def create
    decoded = Auth.decode_token(menu_params['token'])
    user = User.find_by(id: decoded.first['user']['id'])
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
    render json: {link: menu.link, qrcode: menu.qr_code_link}
  end

  def find_menus
    decoded = Auth.decode_token(params[:token])
    user_id_decoded = decoded.first['user']['id']
    user = User.find_by(id: user_id_decoded)
    if user.menus.size > 0
      render json: {last_menu: {has_menu: true, pdf_file: user.menus.last.link, qr_code: user.menus.last.qr_code_link}}
    else
      render json: {last_menu: {menu: false}}
    end
  end

  def resend_qr_code
    decoded = Auth.decode_token(params[:token])
    user_id_decoded = decoded.first['user']['id']
    user = User.find_by(id: user_id_decoded)
    UserMailer.send_qr_code(user).deliver_now
    render json: {status: 'success'}
  end

  private 

  def menu_params
    params.permit(:token, :file)
  end

end
