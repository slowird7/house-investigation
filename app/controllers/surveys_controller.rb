class SurveysController < ApplicationController
  before_action :require_user_logged_in
  
  def show
    @survey = Survey.find(params[:id])
    @house = @survey.house
    @investigation = @house.investigation
    @points = @survey.points
  end

  def new
    @house = House.find(params[:house_id])
    @investigation = @house.investigation
    @survey = @house.surveys.build    
  end

  def create
    @house = House.find(survey_params[:house_id])
    @investigation = @house.investigation
    
    @survey = @house.surveys.build(survey_params)
    if @survey.save
      flash[:success] = '正常に家屋を登録しました。'
      redirect_to @house
    else
      @surveys = @house.surveys.order('created_at DESC')
      flash.now[:danger] = '失敗しました。'
      render :new
    end    
  end

  def edit
    @survey = Survey.find(params[:id])
    @house = @survey.house
    @investigation = @house.investigation
  end

  def update
    @survey = Survey.find(params[:id])

    if @survey.update(survey_params)
      flash[:success] = '正常に更新されました。'
      redirect_to @survey
    else
      flash.now[:danger] = '更新に失敗しました。'
      render :edit
    end      
  end

  def destroy
    @survey = Survey.find(params[:id])
    @house = @survey.house
    @investigation = @house.investigation
    @survey.destroy

    flash[:success] = '正常に削除されました'
    redirect_to @house    
  end
  
  private

  def survey_params
    params.require(:survey).permit(:house_id, :survey_name, :overview, :range)
  end  
end
