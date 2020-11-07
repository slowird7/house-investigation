require 'zip'

class InvestigationsController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    @investigations = Investigation.order(:id)
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
  
  
  def download_images_pre_survey
    @investigation = Investigation.find(params[:id])
    @houses = @investigation.houses.order(house_number: "ASC")
    
    #    dst_file_path = File.join(File.dirname(image_path), File.basename(image_path, '.*') + "_hash" + ".jpg")
    zippath = "#{Rails.root}/tmp/pre_img_withWB.zip"
    
    count = download_images(@houses, "pre", "withWB", zippath)
    if count == 0
      redirect_to @investigation
    end    
  end

  def download_images_ongoing_survey
    @investigation = Investigation.find(params[:id])
    @houses = @investigation.houses.order(house_number: "ASC")

    zippath = "#{Rails.root}/tmp/ongoing_img_withWB.zip"
    
    count = download_images(@houses, "ongoing", "withWB", zippath)
    if count == 0
      redirect_to @investigation
    end     
  end
  
  def download_images_after_survey
    @investigation = Investigation.find(params[:id])
    @houses = @investigation.houses.order(house_number: "ASC")
    
    zippath = "#{Rails.root}/tmp/after_img_withWB.zip"
    
    count = download_images(@houses, "after", "withWB", zippath)
    if count == 0
      redirect_to @investigation
    end     
  end  



  def download_originalImages_pre_survey
    @investigation = Investigation.find(params[:id])
    @houses = @investigation.houses.order(house_number: "ASC")
    
    zippath = "#{Rails.root}/tmp/pre_img.zip"
    
    count = download_images(@houses, "pre", "original", zippath)
    if count == 0
#      redirect_to @investigation
    end
  end

  def download_originalImages_ongoing_survey
    @investigation = Investigation.find(params[:id])
    @houses = @investigation.houses.order(house_number: "ASC")
    
    zippath = "#{Rails.root}/tmp/ongoing_img.zip"    

    count = download_images(@houses, "ongoing", "original", zippath)
    if count == 0
      redirect_to @investigation
    end
  end
  
  def download_originalImages_after_survey
    @investigation = Investigation.find(params[:id])
    @houses = @investigation.houses.order(house_number: "ASC")
    
    zippath = "#{Rails.root}/tmp/after_img.zip"
    
    count = download_images(@houses, "after", "original", zippath)
    if count == 0
      redirect_to @investigation
    end    
  end 

  private

  # Strong Parameter
  def investigation_params
    params.require(:investigation).permit(:content, :construction_name, :construction_display_name1, :construction_display_name2, :builder, :builder_id, :place, 
                                          :investigator_pre_survey, :investigator_ongoing_survey, :investigator_after_survey,
                                          :start_pre_survey, :stop_pre_survey, :start_ongoing_survey, :stop_ongoing_survey, :start_after_survey, :stop_after_survey)
  end
  
  def download_images(houses, survey_type, image_type, zippath)
    count = 0
    if houses.blank?
      return count
    end

    # zip圧縮
    File.unlink zippath if File.file?(zippath)
    Zip::File.open(zippath, Zip::File::CREATE) do |z_fp|

      houses.each do |house|
        sonsyos = house.sonsyos
        if sonsyos.present?
          sonsyos.each do |sonsyo|
            damage = sonsyo.damages.find_by(survey_type: survey_type)
            
            if damage.present?
              if image_type == "original"
                if damage.original_image_url.present?
                  path = damage.original_image_url
                  z_fp.add(File.basename(path), path)
                  count += 1
                end
              elsif image_type == "withWB"
                if damage.image_url.present?
                  path = damage.image_url
                  z_fp.add(File.basename(path), path)
                  count += 1
                end          
              end
            end
          end
        end

        keisyas = house.keisyas
        if keisyas.present?
          keisyas.each do |keisya|
            slope = keisya.slopes.find_by(survey_type: survey_type)
            
            if slope.present?
              if image_type == "original"
                if slope.original_image_url.present?
                  path = slope.original_image_url
                  z_fp.add(File.basename(path), path)
                  count += 1
                end
              elsif image_type == "withWB"
                if slope.image_url.present?
                  path = slope.image_url
                  z_fp.add(File.basename(path), path)
                  count += 1
                end          
              end
            end
          end
        end
        
        points = house.points
        if points.present?
          points.each do |point|
            post = point.posts.find_by(survey_type: survey_type)
            
            if post.present?
              if image_type == "original"        
                if post.original_image_url.present?
                  path = post.original_image_url
                  z_fp.add(File.basename(path), path)
                  count += 1
                end
              elsif image_type == "withWB"
                if post.image_url.present?
                  path = post.image_url
                  z_fp.add(File.basename(path), path)
                  count += 1
                end           
              end
            end  
          end
        end
      end
    end
    send_file(zippath)
    return count
  end
end