class ChoicesController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    @choices = Choice.all
  end

  def new
    @choice = Choice.new
  end

  def create
    @choice = Choice.new(choice_params)

    if @choice.save
      flash[:success] = '正常に登録されました'
      redirect_to choices_url
    else
      flash.now[:danger] = '登録されませんでした'
      render :new
    end
  end

  def edit
    @choice = Choice.find(params[:id])
  end

  def update
    @choice = Choice.find(params[:id])

    if @choice.update(choice_params)
      flash[:success] = '正常に更新されました。'
      redirect_to choices_url
    else
      flash.now[:danger] = '更新に失敗しました。'
      render :edit
    end       
  end

  def destroy
    @choice = Choice.find(params[:id])
    @choice.destroy

    flash[:success] = '正常に削除されました'
    redirect_to choices_url    
  end
  
  private

  # Strong Parameter
  def choice_params
    params.require(:choice).permit(:name, :category)
  end  
end