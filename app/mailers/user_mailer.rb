class UserMailer < ApplicationMailer

  def send_qr_code(user)
    @user = user
    mail(to: @user.email, subject: 'Your QR Code has arrived!')
  end

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to qr-menu.rest')
  end

end
