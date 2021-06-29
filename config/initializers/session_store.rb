if Rails.env === 'production' 
  Rails.application.config.session_store :cookie_store, key: '_qr-menu', domain: 'https://qr-menu.rest/'
else
  Rails.application.config.session_store :cookie_store, key: '_qr-menu' 
end