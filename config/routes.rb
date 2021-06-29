Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#welcome'

  namespace 'api' do
    namespace 'v1' do
      resources :menu
      resources :users, only: [:create, :show, :index]
    end
  end
  
  post '/login', to: 'sessions#create'

end
