class SonsyosController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    @house = House.find(params[:house_id])
    @investigation = @house.investigation

    @sonsyo = @house.sonsyos.build
    last_sonsyo = @house.sonsyos.order('created_at DESC').first
    
    if last_sonsyo != nil
      number = last_sonsyo.number + 1
    else
      number = 1
    end
    
    @sonsyo.number = number
    @sonsyo.room_name = params[:room_name] 
    if @sonsyo.save
      damage = @sonsyo.damages.build
      damage.survey_type = "pre"
      damage.save
      
      damage = @sonsyo.damages.build
      damage.survey_type = "ongoing"
      damage.save
      
      damage = @sonsyo.damages.build
      damage.survey_type = "after"
      damage.save

      flash[:success] = '正常に損傷を登録しました。'
    else
      @sonsyos = @house.sonsyos.order('created_at DESC')
      flash.now[:danger] = '失敗しました。'
    end
    redirect_to @house
  end

  def destroy
    @sonsyo = Sonsyo.find(params[:id])
    @house = @sonsyo.house
    @investigation = @house.investigation
    
    @damages = @sonsyo.damages.destroy_all
    @sonsyo.destroy

    flash[:success] = '正常に削除されました'
    redirect_to @house     
  end

end