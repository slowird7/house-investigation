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

  resources :choices, only: [:index, :new, :create, :edit, :update, :destroy]
    
  resources :investigations do
    member do
      get :pdf_pre_survey
      get :pdf_ongoing_survey
      get :pdf_ongoing2_survey
      get :pdf_after_survey
      
      get :download_images_pre_survey
      get :download_images_ongoing_survey
      get :download_images_after_survey
      
      get :download_originalImages_pre_survey
      get :download_originalImages_ongoing_survey
      get :download_originalImages_after_survey

      get :download_csv_houses
      get :download_csv_pre
      get :download_csv_ongoing
      get :download_csv_after
    end    
  end
  
  resources :houses, only: [:show, :new, :create, :edit, :update, :destroy] do
    member do
      # 所有者
      get :syodakusyo_new_pre_survey
      get :syodakusyo_new_ongoing_survey
      get :syodakusyo_new_after_survey
      get :syodakusyo_show_pre_survey
      get :syodakusyo_show_ongoing_survey
      get :syodakusyo_show_after_survey
      # 居住者      
      get :kyojyusya_syodakusyo_new_pre_survey
      get :kyojyusya_syodakusyo_new_ongoing_survey
      get :kyojyusya_syodakusyo_new_after_survey
      get :kyojyusya_syodakusyo_show_pre_survey
      get :kyojyusya_syodakusyo_show_ongoing_survey
      get :kyojyusya_syodakusyo_show_after_survey
    end
  end
  
  # 測点（レベル）
  resources :points, only: [:create, :edit, :update, :destroy]
  resources :posts, only: [:show, :edit, :update] do
    member do
      get :check
      patch :confirm
    end
  end
  
  # 損傷
  resources :sonsyos, only: [:create, :edit, :update, :destroy]
  resources :damages, only: [:show, :edit, :update] do
    member do
      get :check
      patch :confirm
    end
  end
  
  # 傾斜
  resources :keisyas, only: [:create, :edit, :update, :destroy]  
  resources :slopes, only: [:show, :edit, :update] do
    member do
      get :check
      patch :confirm
    end
  end
end