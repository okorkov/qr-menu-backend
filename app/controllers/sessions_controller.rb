class SessionsController < ApplicationController

  def create

    user = User.find_by(email: params[:email].downcase)

    if user && user.authenticate(params[:password])
      
      token = Auth.create_token(user)

      pdf_file = nil
      qr_code = nil
      uploaded = nil
      has_file = false
      id = nil
      file_name = nil
      if user.menus.last
        pdf_file = user.menus.last.link 
        qr_code = user.menus.last.qr_code_link 
        uploaded = user.menus.last.created_at
        has_file = true
        id = user.menus.last.id
        file_name = user.menus.last.file_name
      end
      links = [] 
      user.links.each {|l| links.push({address: l.address, qr_code: l.qr_code_link})}
      render json:{
                    logged_in: true,
                    last_file: {has_file: has_file, pdf_file: pdf_file, qr_code: qr_code, uploaded: uploaded, id: id},
                    all_files: user.menus.last(20),
                    menu_qr_link: user.id,
                    menu_file: user.file_link,
                    menu_link: user.qr_code_link,
                    token: token,
                    links: links
                  }, status: 200
			
    else
      render json: {errors: "Email or Password is incorrect"}, status: 200
    end
  end

  def is_logged_in?
    decoded = Auth.decode_token(params[:token])
    user = User.find_by(email: decoded.first['user']['email'])
    if user
      pdf_file = nil
      qr_code = nil
      uploaded = nil
      has_file = false
      id = nil
      file_name = nil
      if user.menus.last
        pdf_file = user.menus.last.link 
        qr_code = user.menus.last.qr_code_link 
        uploaded = user.menus.last.created_at
        has_file = true
        id = user.menus.last.id
        file_name = user.menus.last.file_name
      end
      links = [] 
      user.links.each {|l| links.push({address: l.address, qr_code: l.qr_code_link, id: l.id})}
      render json:{
                    logged_in: true, 
                    last_file: {has_file: has_file, pdf_file: pdf_file, qr_code: qr_code, uploaded: uploaded, id: id},
                    all_files: user.menus.last(50),
                    menu_qr_link: user.id,
                    menu_file: user.file_link,
                    menu_link: user.qr_code_link,
                    links: links
                  }
    elsif
      render json: {logged_in: false, status: 'success'}
    end
  end

  def google_auth
    user = User.find_or_create_by(google_params)
    user.password = SecureRandom.hex(10)
    user.save
    if user
      token = Auth.create_token(user)
      pdf_file = nil
      qr_code = nil
      uploaded = nil
      has_file = false
      id = nil
      file_name = nil
      if user.menus.last
        pdf_file = user.menus.last.link 
        qr_code = user.menus.last.qr_code_link 
        uploaded = user.menus.last.created_at
        has_file = true
        id = user.menus.last.id
        file_name = user.menus.last.file_name
      end
      links = [] 
      user.links.each {|l| links.push({address: l.address, qr_code: l.qr_code_link})}
      render json:{
                    logged_in: true,
                    last_file: {has_file: has_file, pdf_file: pdf_file, qr_code: qr_code, uploaded: uploaded, id: id},
                    all_files: user.menus.last(20),
                    menu_qr_link: user.id,
                    menu_file: user.file_link,
                    menu_link: user.qr_code_link,
                    token: token,
                    links: links
                  }, status: 200
			
    else
      render json: {errors: "failed oauth"}
    end
  end

  private

  def google_params
    params.permit(:email)
  end

end