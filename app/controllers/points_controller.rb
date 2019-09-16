class PointsController < ApplicationController
  before_action :require_user_logged_in  
  
  def show
    @point = Point.find(params[:id])
    @survey = @point.survey
    @house = @survey.house
    @investigation = @house.investigation    
  end

  def new
    @survey = Survey.find(params[:survey_id])
    @house = @survey.house
    
    @pre_survey = @house.surveys.find_by(survey_name: "事前調査")
    @ongoing_survey = @house.surveys.find_by(survey_name: "事中調査")
    @after_survey = @house.surveys.find_by(survey_name: "事後調査")
    @other_survey = @house.surveys.find_by(survey_name: "その他")
    
    @investigation = @house.investigation
    @point = @survey.points.build
  end

  def create
    @survey = Survey.find(point_params[:survey_id])
    @house = @survey.house
    @investigation = @house.investigation
    
    @point = @survey.points.build(point_params)
    if @point.save
      flash[:success] = '正常に家屋を登録しました。'
      redirect_to @survey
    else
      @points = @survey.points.order('created_at DESC')
      flash.now[:danger] = '失敗しました。'
      render :new
    end
  end

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

  def destroy
    @point = Point.find(params[:id])
    @survey = @point.survey
    @house = @survey.house
    @investigation = @house.investigation
    
    @point.destroy

    flash[:success] = '正常に削除されました'
    redirect_to @survey     
  end
  
  private

  def point_params
    params.require(:point).permit(:survey_id, :genkyo, :sukima, :ware, :kake, :amimejyo, :zencho, :sokuten, :crack, :tile, :kire, :uki, :suhon, :zenshu,
                                  :suichokukeisya, :chirigire, :cross, :meji, :tategu, :tasu, :kakusyo, :suiheikeisya, :wide, :height, :length, :comment,
                                  :image1, :image2, :image3, :image1_cache, :image2_cache, :image3_cache)
  end    
end
