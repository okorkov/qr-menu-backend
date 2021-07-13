class SessionsController < ApplicationController

  def create

    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      
      token = Auth.create_token(user)

      pdf_file = nil
      qr_code = nil
      uploaded = nil
      has_file = false
      if user.menus.last
        pdf_file = user.menus.last.link 
        qr_code = user.menus.last.qr_code_link 
        uploaded = user.menus.last.created_at
        has_file = true
      end
      render json:{
                    logged_in: true,
                    last_file: {has_file: has_file, pdf_file: pdf_file, qr_code: qr_code, uploaded: uploaded},
                    all_files: user.menus.last(20),
                    menu_qr_link: user.id,
                    menu_file: user.file_link,
                    menu_link: user.qr_code_link,
                    token: token,

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
      if user.menus.last
        pdf_file = user.menus.last.link 
        qr_code = user.menus.last.qr_code_link 
        uploaded = user.menus.last.created_at
        has_file = true
      end
      render json:{
                    logged_in: true, 
                    last_file: {has_file: has_file, pdf_file: pdf_file, qr_code: qr_code, uploaded: uploaded},
                    all_files: user.menus.last(20),
                    menu_qr_link: user.id,
                    menu_file: user.file_link,
                    menu_link: user.qr_code_link,
                  }
    elsif
      render json: {logged_in: false, status: 'success'}
    end
    
  end

  def destroy
    decoded = Auth.decode_token(params[:token])
    if User.find_by(email: decoded.first['user']['email'])
      render json: {can_be_logged_out: true, status: 'success'}
    elsif
      render json: {can_be_logged_out: false, status: 'success'}
    end
  end

end