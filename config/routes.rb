Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#welcome'

  namespace 'api' do
    namespace 'v1' do
      resources :menus
      resources :links, only: [:create]
      post '/links/:qr_code_address', to: 'links#destroy'
      post '/find_menus', to: 'menus#find_menus'
      get '/demo', to: 'menus#demo'
      post '/resend_qr_code', to: 'menus#resend_qr_code'
      post '/demo_upload', to: 'menus#demo_upload'
      post '/menus/:id', to: 'menus#destroy'
    end
  end

  post '/generate_qr_for_menu' , to: 'users#generate_qr_for_menu'
  post '/upload_file', to: 'users#upload_file'
  get '/get_menu/:id', to: 'users#get_menu'
  post '/resend_qr_menu', to: 'users#resend_qr_menu'

  resources :users, only: [:create]
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  post '/logged_in', to: 'sessions#is_logged_in?'
  post '/google_auth', to: 'sessions#google_auth'

 
  
end
