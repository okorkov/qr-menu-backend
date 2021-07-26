class Api::V1::LinksController < ApplicationController
  
  before_action :user

  def create
    new_link = Link.new(address: menu_params[:input], user_id: user.id)
    qrcode = RQRCode::QRCode.new(new_link.address)
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
    new_link.qr_code.attach(io: StringIO.new(png.to_s), filename: "qr_link.png")
    new_link.qr_code_link = new_link.qr_code.url.sub(/\?.*/, '')
    new_link.save
    render json: {address: new_link.address, qr_code: new_link.qr_code_link, id: new_link.id}
  end

  def destroy
    if user
      if Link.find(delete_params[:qr_code_address]).destroy
        render json: {status: 'success', id: delete_params[:qr_code_address]}
      else
        render json: {status: 'failed'}
      end
    else
      render json: {status: 'failed'}
    end
  end

  private 

  def menu_params
    params.permit(:token, :input)
  end

  def delete_params 
    params.permit(:qr_code_address)
  end

end