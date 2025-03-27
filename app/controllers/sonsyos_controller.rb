class SonsyosController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    @house = House.find(params[:house_id])
    @investigation = @house.investigation

    @sonsyo = @house.sonsyos.build
    @sonsyo.room_name = params[:area2]
    @sonsyo.room_name_other = params[:other]
    #@sonsyo.number = number

    if @sonsyo.save
      # 番号のアップデート
      update_number(@house.sonsyos)
      
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
      redirect_to house_path(@house, anchor: 'sonsyo_id_'+ @sonsyo.id.to_s)
    else
      @sonsyos = @house.sonsyos.order('created_at DESC')
      flash.now[:danger] = '失敗しました。'
      redirect_to house_path(@house, anchor: 'sonsyo')
    end
  end
  
  def edit
    @sonsyo = Sonsyo.find(params[:id])
    @house = @sonsyo.house
    @investigation = @house.investigation
  end  
  
  def update
    @sonsyo = Sonsyo.find(params[:id])
    @house = @sonsyo.house
    @investigation = @house.investigation

    @sonsyo.room_name = params[:area2]
    @sonsyo.room_name_other = params[:other]
    
    if @sonsyo.save
      # 番号のアップデート
      update_number(@house.sonsyos)
      
      flash[:success] = '正常に損傷を登録しました。'      
    else
      flash.now[:danger] = '失敗しました。'
    end

    redirect_to house_path(@house, anchor: 'sonsyo')
  end

  def destroy
    @sonsyo = Sonsyo.find(params[:id])
    @house = @sonsyo.house
    @investigation = @house.investigation
    
    @damages = @sonsyo.damages.destroy_all
    @sonsyo.destroy
    
    # 番号のアップデート
    update_number(@house.sonsyos)

    flash[:success] = '正常に削除されました'
    #redirect_to @house
    redirect_to house_path(@house, anchor: 'sonsyo')
  end
  
  private
  
  def update_number(sonsyos)
    flag = true # 成功
    number = 1
    
    # 全景
    sonsyos.each do |sonsyo|
      if sonsyo.room_name == "全景"
        sonsyo.number = number
        number = number + 1
      end
    end

    # 非全景
    sonsyos.each do |sonsyo|
      if sonsyo.room_name != "全景"
        sonsyo.number = number
        number = number + 1
      end
    end    
    
    # 保存
    sonsyos.each do |sonsyo|
      if !sonsyo.save
        flag = false # 失敗
      end
    end
    
    return flag
  end
end
