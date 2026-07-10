Rails.application.routes.draw do
  root "static_pages#top"

  namespace :admin do
    root "dashboards#index"
    resource :dashboard, only: %i[index]
    get 'login' => 'user_sessions#new', :as => :login
    post 'login' => 'user_sessions#create'
    delete 'logout' => 'user_sessions#destroy', :as => :logout
  end

  resources :users, only: %i[new create] 
  resource :profile, only: %i[show edit update]
  resources :boards, only: %i[index new create show edit update destroy] do
    resources :comments, only: %i[create edit destroy], shallow: true
    collection do
      get :bookmarks
    end
  end



  resources :bookmarks, only: %i[create destroy]
  resources :password_resets, only: %i[new create edit update]
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?


end
