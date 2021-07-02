Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#welcome'

  namespace 'api' do
    namespace 'v1' do
      resources :menus
      resources :users, only: [:create, :show, :index]
      post '/find_menus', to: 'menus#find_menus'
      post '/resend_qr_code', to: 'menus#resend_qr_code'
    end
  end

  resources :users, only: [:create]
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  post '/logged_in', to: 'sessions#is_logged_in?'
 
  
end
