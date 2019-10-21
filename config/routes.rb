Rails.application.routes.draw do
  constraints ->  request { request.session[:user_id].present? } do
    # ログインしてる時のパス
    root to: 'investigations#index'
  end
  # ログインしてない時のパス
  root to: 'sessions#new'
  
  # セッション
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
    
  get 'signup', to: 'users#new'
  resources :users
    
  resources :investigations do
    member do
      get :pdf_pre_survey
      get :pdf_ongoing_survey
      get :pdf_after_survey
    end
  end
  resources :houses, only: [:show, :new, :create, :edit, :update, :destroy]
  resources :points, only: [:create, :destroy]
  resources :choices, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :posts, only: [:show, :edit, :update]
end