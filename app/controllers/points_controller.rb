class PointsController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    @house = House.find(params[:house_id])
    @investigation = @house.investigation

    @point = @house.points.build
    last_point = @house.points.order('created_at DESC').first
    
    if last_point != nil
      number = last_point.number + 1
    else
      number = 1
    end
    
    @point.number = number
    @point.room_name = params[:room_name]
    @point.room_name_other = params[:other]    
    
#    if params[:other] != ""
#      if params[:room_name] == "外部（その他）"
#        @point.room_name = params[:other]
#      else
#        @point.room_name = params[:room_name] + "/" + params[:other]
#      end
#    else
#       @point.room_name = params[:room_name]
#    end
    
    if @point.save
      post = @point.posts.build
      post.survey_type = "pre"
      post.save
      
      post = @point.posts.build
      post.survey_type = "ongoing"
      post.save
      
      post = @point.posts.build
      post.survey_type = "after"
      post.save
      
      flash[:success] = '正常に測点（レベル）を登録しました。'
    else
      @points = @house.points.order('created_at DESC')
      flash.now[:danger] = '失敗しました。'
    end
    #redirect_to @house
    redirect_to house_path(@house, anchor: 'point')
  end
  
  def edit
    @point = Point.find(params[:id])
    @house = @point.house
    @investigation = @house.investigation
  end  
  
  def update
    @point = Point.find(params[:id])
    @house = @point.house
    @investigation = @house.investigation
    
    @point.room_name = params[:room_name]
    @point.room_name_other = params[:other]
    
    if @point.save
      flash[:success] = '正常に損傷を登録しました。'      
    else
      flash.now[:danger] = '失敗しました。'
    end

    redirect_to house_path(@house, anchor: 'point')
  end  

  def destroy
    @point = Point.find(params[:id])
    @house = @point.house
    @investigation = @house.investigation
    
    @posts = @point.posts.destroy_all
    @point.destroy

    flash[:success] = '正常に削除されました'
    #redirect_to @house
    redirect_to house_path(@house, anchor: 'point')
  end
end
