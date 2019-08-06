class HousesController < ApplicationController
  before_action :require_user_logged_in
  
  def new
    @investigation = Investigation.find(params[:investigation_id])
    @house = @investigation.houses.build
  end

  def create
    # binding.pry
    
    @investigation = Investigation.find(house_params[:investigation_id])
    
    @house = @investigation.houses.build(house_params)
    if @house.save
      flash[:success] = '正常に家屋を登録しました。'
      redirect_to @investigation
    else
      @houses = @investigation.houses.order('created_at DESC')
      flash.now[:danger] = '失敗しました。'
      render @investigation
    end    
  end

  def show
    @house = House.find(params[:id])
    @investigation = @house.investigation
  end
  
  def edit
    @house = House.find(params[:id])
    @investigation = @house.investigation    
  end

  def update
    @house = House.find(params[:id])

    if @house.update(house_params)
      flash[:success] = '正常に更新されました。'
      redirect_to @house
    else
      flash.now[:danger] = '更新に失敗しました。'
      render :edit
    end     
  end

  def destroy
    # binding.pry
    
    @house = House.find(params[:id])
    @investigation = @house.investigation
    @house.destroy

    flash[:success] = '正常に削除されました'
    redirect_to @investigation
  end
  
  private

  def house_params
    params.require(:house).permit(:house_name, :prefectures, :city, :block, :owner, :investigation_id)
  end  
end
