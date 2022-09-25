Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root to: 'windows#open', as: :authenticated_root
  end

  root to: 'pages#home'

  resources :windows, except: %i[index] do
    resources :lists, except: %i[index], shallow: true do
      resources :items, only: %i[new create destroy], shallow: true
    end
    collection do
      get :open
      get :closed
    end
    member do
      get :lists
      get :windows
    end
  end
end
