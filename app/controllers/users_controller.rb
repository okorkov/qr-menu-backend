class UsersController < ApplicationController



  def create
    user = User.new(user_params)
    if user.save
      UserMailer.welcome_email(user).deliver_now
      token = Auth.create_token(user)
      render json: {token: token, logged_in: true, menu_qr_link: user.id,}, status: 200
    else
      render json: {errors: user.errors, logged_in: false, status: 500}, status: 200
    end
  end

  def generate_qr_for_menu
    decoded = Auth.decode_token(menu_params[:token])
    user = User.find_by(id: decoded.first['user']['id'])
    domain = "https://#{menu_params[:domain]}"
    qrcode = RQRCode::QRCode.new(domain)
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
    user.qr_code.attach(io: StringIO.new(png.to_s), filename: "qr_code_#{user.id}.png")
    user.qr_code_link = user.qr_code.url.sub(/\?.*/, '')
    user.save
    render json: {qr_code_link: user.qr_code_link, status: 'success', domain: domain}
  end

  def upload_file
    decoded = Auth.decode_token(menu_params[:token])
    user = User.find_by(id: decoded.first['user']['id'])
    user.file.purge if  user.file.attached?
    user.file.attach(menu_params['file'])
    user.file_link = user.file.url.sub(/\?.*/, '')
    user.save
    render json: {file_link: user.file_link, status: 'success'}
  end

  def get_menu
    user = User.find_by(find_menu_params)
    if user
      if user.file_link
        render json: {has_file: true, menu_link: user.file_link}
      else
        render json: {has_file: false}
      end
    else
      render json: {has_file: false}
    end
  end

  def resend_qr_menu
    UserMailer.send_qr_menu(user).deliver_now
    render json: {status: 'success'}
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

  def menu_params
    params.permit(:token, :file, :domain, user: {})
  end

  def find_menu_params
    params.permit(:id)
  end


end