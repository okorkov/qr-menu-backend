module MenusHelper

  def user
    decoded = Auth.decode_token(menu_params[:token])
    user = User.find_by(id: decoded.first['user']['id'])
  end

  def attach_pdf_and_qr_code
    # menu = Menu.new
    # menu.user = user
    # menu.pdf_file.attach(menu_params['file'])
    # menu.link = menu.pdf_file.url.sub(/\?.*/, '')
    # qrcode = RQRCode::QRCode.new(menu.link)
    # png = qrcode.as_png(
    #   bit_depth: 1,
    #   border_modules: 4,
    #   color_mode: ChunkyPNG::COLOR_GRAYSCALE,
    #   color: "black",
    #   file: nil,
    #   fill: "white",
    #   module_px_size: 8,
    #   resize_exactly_to: false,
    #   resize_gte_to: false,
    #   size: 400
    # )
    # menu.qr_code.attach(io: StringIO.new(png.to_s), filename: "qr_code_#{menu.id}.png")
    # menu.qr_code_link = menu.qr_code.url.sub(/\?.*/, '')
    # menu.save
  end

end