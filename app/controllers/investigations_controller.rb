class InvestigationsController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    @investigations = Investigation.all
  end

  def show
    @investigation = Investigation.find(params[:id])
    @houses = @investigation.houses.order(house_number: "ASC")
  end

  def new
    @investigation = Investigation.new
  end

  def create
    @investigation = Investigation.new(investigation_params)
    if @investigation.save
      flash[:success] = '正常に登録されました'
      redirect_to @investigation
    else
      flash.now[:danger] = '登録されませんでした'
      render :new
    end
  end

  def edit
    @investigation = Investigation.find(params[:id])
  end

  def update
    @investigation = Investigation.find(params[:id])

    if @investigation.update(investigation_params)
      flash[:success] = '正常に更新されました。'
      redirect_to root_url
    else
      flash.now[:danger] = '更新に失敗しました。'
      render :edit
    end    
  end

  def destroy
    @investigation = Investigation.find(params[:id])
    @investigation.destroy

    flash[:success] = '正常に削除されました'
    redirect_to investigations_url
  end
  
  def pdf_pre_survey
    @investigation = Investigation.find(params[:id])
    @houses = @investigation.houses.order(house_number: "ASC")
  end
  
  def pdf_ongoing_survey
    @investigation = Investigation.find(params[:id])
    @houses = @investigation.houses.order(house_number: "ASC")    
  end
  
  def pdf_ongoing2_survey
    @investigation = Investigation.find(params[:id])
    @houses = @investigation.houses.order(house_number: "ASC")    
  end
  
  def pdf_after_survey
    @investigation = Investigation.find(params[:id])
    @houses = @investigation.houses.order(house_number: "ASC")    
  end
  
  def list_images_pre_survey
    @investigation = Investigation.find(params[:id])
    @houses = @investigation.houses.order(house_number: "ASC")
  end

  def list_images_ongoing_survey
    @investigation = Investigation.find(params[:id])
    @houses = @investigation.houses.order(house_number: "ASC")
  end
  
  def list_images_after_survey
    @investigation = Investigation.find(params[:id])
    @houses = @investigation.houses.order(house_number: "ASC")
  end  

  def list_plainImages_pre_survey
    @investigation = Investigation.find(params[:id])
    @houses = @investigation.houses.order(house_number: "ASC")
  end

  def list_plainImages_ongoing_survey
    @investigation = Investigation.find(params[:id])
    @houses = @investigation.houses.order(house_number: "ASC")
  end
  
  def list_plainImages_after_survey
    @investigation = Investigation.find(params[:id])
    @houses = @investigation.houses.order(house_number: "ASC")
  end 

  private

  # Strong Parameter
  def investigation_params
    params.require(:investigation).permit(:content, :construction_name, :builder, :builder_id, :place, :investigator_pre_survey, :investigator_ongoing_survey, :investigator_after_survey)
  end
end
