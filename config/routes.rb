Rails.application.routes.draw do
  constraints ->  request { request.session[:user_id].present? } do
    # ログインしてる時のパス
    root to: 'investigations#index'
  end
  # ログインしてない時のパス
  root to: 'toppages#index'
  
  # セッション
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
    
  get 'signup', to: 'users#new'
  resources :users
    
  resources :investigations
  
  resources :houses, only: [:new, :show, :create, :edit, :update, :destroy]
end
