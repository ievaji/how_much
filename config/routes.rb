Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :windows do
    resources :lists, shallow: true
  end

  resources :items, only: %i[create edit destroy]
end
