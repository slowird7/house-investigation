class SlopesController < ApplicationController
  before_action :require_user_logged_in

  def show
    @slope = Slope.find(params[:id])
    @keisya = @slope.keisya
    @house = @keisya.house
    @investigation = @house.investigation
  end
  
  def edit
    @keisya = Keisya.find(params[:keisya_id])
    @slope = @keisya.slopes.find_by(survey_type: params[:survey_type])
    @house = @keisya.house
    @investigation = @house.investigation
    
    @preview_slope = @keisya.slopes.find_by(survey_type: "pre")
    if params[:survey_type] == "after"
      @preview_slope = @keisya.slopes.find_by(survey_type: "ongoing")
      unless @preview_slope.image1?
        @preview_slope = @keisya.slopes.find_by(survey_type: "pre")
      end
    end
  end
  
  def update
    @slope = Slope.find(params[:id])
    @keisya = @slope.keisya
    @house = @keisya.house
    @investigation = @house.investigation

    # imageを更新
    tmp_slope_params = slope_params
    image_data = base64_conversion(tmp_slope_params[:image_url])
    tmp_slope_params[:image1] = image_data
    tmp_slope_params[:image_url] = nil

    if @slope.update(tmp_slope_params)  
      # 調査開始日・終了日の更新
      if @slope.survey_type == "pre"
        if @investigation.start_pre_survey == nil
          @investigation.start_pre_survey = Date.today
        end
        @investigation.stop_pre_survey = Date.today
      elsif @slope.survey_type == "ongoing"
        if @investigation.start_ongoing_survey == nil
          @investigation.start_ongoing_survey = Date.today
        end      
        @investigation.stop_ongoing_survey = Date.today      
      else
        if @investigation.start_after_survey == nil
          @investigation.start_after_survey = Date.today
        end      
        @investigation.stop_after_survey = Date.today
      end
      @investigation.save

      flash[:success] = '正常に更新されました。'
      redirect_to @house
    else
      flash.now[:danger] = '更新に失敗しました。'
      render :edit
    end  
  end
  
  private

  def slope_params
    params.require(:slope).permit(:keisya_id, :position_wb, :suichokukeisya, :suiheikeisya, :east, :west, :north, :south, :comment,
                                  :image1, :image2, :image3, :image1_cache, :image2_cache, :image3_cache, :survey_type, :image_url)
  end

  def base64_conversion(uri_str, filename = 'base64')
    image_data = split_base64(uri_str)
    image_data_string = image_data[:data]
    image_data_binary = Base64.decode64(image_data_string)

    temp_img_file = Tempfile.new(filename)
    temp_img_file.binmode
    temp_img_file << image_data_binary
    temp_img_file.rewind

    img_params = {:filename => "#{filename}.#{image_data[:extension]}", :type => image_data[:type], :tempfile => temp_img_file}
    ActionDispatch::Http::UploadedFile.new(img_params)
  end

  def split_base64(uri_str)
    if uri_str.match(%r{data:(.*?);(.*?),(.*)$})
      uri = Hash.new
      uri[:type] = $1
      uri[:encoder] = $2
      uri[:data] = $3
      uri[:extension] = $1.split('/')[1]
      return uri
    else
      return nil
    end
  end  
end