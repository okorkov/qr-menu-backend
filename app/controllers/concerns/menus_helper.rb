module MenusHelper

  def user
    decoded = Auth.decode_token(menu_params[:token])
    user = User.find_by(id: decoded.first['user']['id'])
  end

  def generate_qr_code(link)
    qrcode = RQRCode::QRCode.new(link)
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
  end

  def user_json(user, token = nil)
    pdf_file = nil
    qr_code = nil
    uploaded = nil
    has_file = false
    id = nil
    file_name = nil
    links = user.links 
    if user.menus.last
      pdf_file = user.menus.last.link 
      qr_code = user.menus.last.qr_code_link 
      uploaded = user.menus.last.created_at
      has_file = true
      id = user.menus.last.id
      file_name = user.menus.last.file_name
    end
    user_json = {
      logged_in: true, 
      last_file: {has_file: has_file, pdf_file: pdf_file, qr_code: qr_code, uploaded: uploaded, id: id},
      all_files: user.menus.last(50),
      menu_qr_link: user.id,
      menu_file: user.file_link,
      menu_link: user.qr_code_link,
      links: links,
      token: token
    }
  end

end