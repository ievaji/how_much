Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root to: 'windows#open', as: :authenticated_root
  end

  root to: 'pages#home'

  resources :windows, only: %i[create show edit destroy] do
    resources :lists, shallow: true
    collection do
      get :open
      get :closed
    end
  end
  # Might need to rethink this. What actually needs to be nested inside?
  # Is it Lists in Windows or Items in Lists?
  resources :items, only: %i[create destroy]
end
