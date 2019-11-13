class KeisyasController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    @house = House.find(params[:house_id])
    @investigation = @house.investigation

    @keisya = @house.keisyas.build
    last_keisya = @house.keisyas.order('created_at DESC').first
    
    if last_keisya != nil
      number = last_keisya.number + 1
    else
      number = 1
    end
    
    @keisya.number = number
    @keisya.room_name = params[:room_name]    
    if @keisya.save
      slope = @keisya.slopes.build
      slope.survey_type = "pre"
      slope.save
      
      slope = @keisya.slopes.build
      slope.survey_type = "ongoing"
      slope.save
      
      slope = @keisya.slopes.build
      slope.survey_type = "after"
      slope.save

      flash[:success] = '正常に傾斜を登録しました。'
    else
      @keisya = @house.keisya.order('created_at DESC')
      flash.now[:danger] = '失敗しました。'
    end
    redirect_to @house
  end

  def destroy
    @keisya = Keisya.find(params[:id])
    @house = @keisya.house
    @investigation = @house.investigation
    
    @slopes = @keisya.slopes.destroy_all
    @keisya.destroy

    flash[:success] = '正常に削除されました'
    redirect_to @house     
  end
end
