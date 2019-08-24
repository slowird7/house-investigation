class UsersController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    # 非管理者（オペレーター）の場合
    unless current_user.role == "admin" || current_user.role == "superuser"
      redirect_to root_url
    end
    
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    # 非管理者（オペレーター）の場合
    unless current_user.role == "admin" || current_user.role == "superuser"
      redirect_to root_url
    end

    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to users_url
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:success] = '正常に更新されました。'
      redirect_to users_url
    else
      flash.now[:danger] = '更新に失敗しました。'
      render :edit
    end
  end  
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    flash[:success] = '正常に削除されました'
    redirect_to users_url
  end
  
  private

  def user_params
    params.require(:user).permit(:role, :user_name, :password, :password_confirmation)
  end
end
