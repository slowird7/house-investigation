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
    @keisya.room_name = params[:area4]
    @keisya.room_name_other = params[:other]
    
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
      redirect_to house_path(@house, anchor: 'keisya_id_'+ @keisya.id.to_s)
    else
      @keisya = @house.keisya.order('created_at DESC')
      flash.now[:danger] = '失敗しました。'
      redirect_to house_path(@house, anchor: 'keisya')
    end
  end
  
  def edit
    @keisya = Keisya.find(params[:id])
    @house = @keisya.house
    @investigation = @house.investigation
  end  
  
  def update
    @keisya = Keisya.find(params[:id])
    @house = @keisya.house
    @investigation = @house.investigation
    
    @keisya.room_name = params[:area4]
    @keisya.room_name_other = params[:other]
    
    if @keisya.save
      flash[:success] = '正常に損傷を登録しました。'      
    else
      flash.now[:danger] = '失敗しました。'
    end

    redirect_to house_path(@house, anchor: 'keisya')
  end

  def destroy
    @keisya = Keisya.find(params[:id])
    @house = @keisya.house
    @investigation = @house.investigation
    
    @slopes = @keisya.slopes.destroy_all
    @keisya.destroy

    flash[:success] = '正常に削除されました'
    #redirect_to @house
    redirect_to house_path(@house, anchor: 'keisya')
  end
end
