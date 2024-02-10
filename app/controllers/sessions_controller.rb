class SessionsController < ApplicationController
  def new
  end

  def create
    user_name = params[:session][:user_name]
    password = params[:session][:password]
    if login(user_name, password)
      flash[:success] = 'ログインに成功しました。'
      redirect_to root_url
    else
      flash.now[:danger] = 'ログインに失敗しました。'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url    
  end
  
  private

  def login(user_name, password)
    @user = User.find_by(user_name: user_name)
    if @user && @user.authenticate(password)
      # ログイン成功
      session[:user_id] = @user.id
      return true
    else
      # ログイン失敗
      return false
    end
  end  
end
