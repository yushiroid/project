Rails.application.routes.draw do

  constraints ->  request { request.session[:user_id].present? } do
    root to: 'users#mypage'
  end
  root to: 'users#mypage'
  #root to: 'pages#home'

  get 'edit', to: 'users#edit'

  get 'login', to: 'sessions#new', as: :login
  post 'login', to: 'sessions#create'
  post 'logout', to: 'sessions#destroy', as: :logout

  #Facebook login
  post 'oauth/callback', to: 'oauths#callback'
  get 'oauth/callback', to: 'oauths#callback'
  get 'oauth/:provider', to: 'oauths#oauth', as: :auth_at_provider


  resources :users, :groups

  resources :groups do
    resources :group_users
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
