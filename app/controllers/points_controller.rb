class PointsController < ApplicationController
  before_action :require_user_logged_in
  
=begin 
  # 使ってない
  def show
    @point = Point.find(params[:id])
    @house = @point.house
    @investigation = @house.investigation
  end

  def new
    @house = House.find(params[:house_id])
    @investigation = @house.investigation
    @point = @house.points.build
    @post = @point.posts.build
  end
=end
  
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
    redirect_to @house
  end

=begin 
  # 使ってない
  def edit
    @point = Point.find(params[:id])
    @survey = @point.survey
    @house = @survey.house
    @investigation = @house.investigation    
  end

  def update
    @point = Point.find(params[:id])

    if @point.update(point_params)
      flash[:success] = '正常に更新されました。'
      redirect_to @point
    else
      flash.now[:danger] = '更新に失敗しました。'
      render :edit
    end       
  end
=end 

  def destroy
    @point = Point.find(params[:id])
    @house = @point.house
    @investigation = @house.investigation
    
    @posts = @point.posts.destroy_all
    @point.destroy

    flash[:success] = '正常に削除されました'
    redirect_to @house     
  end

=begin 
  # 使ってない
  private

  def point_params
    params.require(:point).permit(:house_id, :number)
  end
=end

end
