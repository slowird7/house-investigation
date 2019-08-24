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
    
  resources :investigations
  resources :houses, only: [:show, :new, :create, :edit, :update, :destroy]
  resources :surveys, only: [:show, :new, :create, :edit, :update, :destroy]
  resources :points, only: [:show, :new, :create, :edit, :update, :destroy]
  
  resources :choices, only: [:index, :new, :create, :edit, :update, :destroy]
end
