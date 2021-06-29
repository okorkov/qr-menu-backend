Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#welcome'

  namespace 'api' do
    namespace 'v1' do
      resources :menus, only: [:create, :update, :destroy]
      resources :sessions, only: [:create, :destroy]
    end
  end
end
