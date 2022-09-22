Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root to: 'windows#open', as: :authenticated_root
  end

  root to: 'pages#home'

  resources :windows, only: %i[new create show edit destroy] do
    resources :windows, only: %i[index]
    resources :lists, only: %i[new create show edit destroy], shallow: true do
      resources :items, only: %i[new create destroy], shallow: true
    end
    collection do
      get :open
      get :closed
    end
  end
end
