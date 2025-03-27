require './lib/jacic_hash_lib'
require 'mini_exiftool'
include JACICHash

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

    # paramsは代入できないので、コピーを生成
    copy_slope_params = slope_params
    # canvasの画像化
    copy_slope_params[:image2] = base64_conversion(params[:canvas_data])

    if @slope.update(copy_slope_params)
      # 信憑性のチェック（ハッシュ値の付加）
      dst_file_path = check_credibility(@slope.image1.path)
      # 相対パスに変換
      @slope.original_image_url = dst_file_path
      # ハッシュ付き画像も保存
      @slope.save
      
      redirect_to check_slope_path
    else
      flash.now[:danger] = '更新に失敗しました。'
      render :edit
    end
  end
  
  def check
    @slope = Slope.find(params[:id])
    @keisya = @slope.keisya
    @house = @keisya.house
    @investigation = @house.investigation
  end    
  
  def confirm
    @slope = Slope.find(params[:id])
    @keisya = @slope.keisya
    @house = @keisya.house
    @investigation = @house.investigation
    
    # paramsは代入できないので、コピーを生成
    copy_slope_params = slope_params    
    # canvasの画像化
    copy_slope_params[:image3] = base64_conversion(params[:canvas_data])
    @slope.update(copy_slope_params)

    # オリジナル写真のEXIF情報を取得し、ホワイトボード付き写真のEXIFに上書き
    exif1 = MiniExiftool.new(@slope.image1.path)
    exif3 = MiniExiftool.new(@slope.image3.path)
    exif3.date_time_original = exif1.date_time_original
    exif3.save

    # 信憑性のチェック（ハッシュ値の付加）
    dst_file_path = check_credibility(@slope.image3.path)
    if dst_file_path != nil
      @slope.image_url = dst_file_path
    end
    
    # ハッシュ付き画像も保存
    if @slope.save
      # 調査日の更新
      update_survey_day(@house, @slope)
      
      flash[:success] = '正常に更新されました。'
      redirect_to house_path(@house, anchor: 'keisya')
    else
      flash.now[:danger] = '更新に失敗しました。'
      render :confirm
    end    
  end
  
  private

  def slope_params
    params.require(:slope).permit(:keisya_id, :position_wb, :suichokukeisya, :suiheikeisya, :east, :west, :north, :south, :comment,
                                  :image1, :image2, :image3, :image1_cache, :image2_cache, :image3_cache, :survey_type, :image_url)
  end
end
