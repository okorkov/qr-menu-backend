class Api::V1::LinksController < ApplicationController
  
  before_action :user

  def create
    new_link = Link.new(address: menu_params[:input], user_id: user.id)
    png = generate_qr_code(new_link.address)
    new_link.qr_code.attach(io: StringIO.new(png.to_s), filename: "qr_link.png")
    new_link.qr_code_link = new_link.qr_code.url.sub(/\?.*/, '')
    new_link.save
    render json: new_link
  end

  def destroy
    if user
      if Link.find(delete_params[:id]).destroy
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
    params.permit(:token, :input)
  end

  def delete_params 
    params.permit(:id)
  end

end