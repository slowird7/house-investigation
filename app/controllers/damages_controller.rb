require './lib/jacic_hash_lib'
require 'mini_exiftool'
include JACICHash

class DamagesController < ApplicationController
  before_action :require_user_logged_in
  before_action :damage_params, only: [:update, :confirm]
  
  def show
    @damage = Damage.find(params[:id])
    @sonsyo = @damage.sonsyo
    @house = @sonsyo.house
    @investigation = @house.investigation
  end

  def edit
    @sonsyo = Sonsyo.find(params[:sonsyo_id])
    @damage = @sonsyo.damages.find_by(survey_type: params[:survey_type])
    @house = @sonsyo.house
    @investigation = @house.investigation
    
    @preview_damage = @sonsyo.damages.find_by(survey_type: "pre")
    if params[:survey_type] == "after"
      @preview_damage = @sonsyo.damages.find_by(survey_type: "ongoing")
      unless @preview_damage.image1?
        @preview_damage = @sonsyo.damages.find_by(survey_type: "pre")
      end
    end    
  end

  def update
    @damage = Damage.find(params[:id])
    @sonsyo = @damage.sonsyo
    @house = @sonsyo.house
    @investigation = @house.investigation

    # paramsは代入できないので、コピーを生成
    copy_damage_params = damage_params
    # canvasの画像化
    #binding.pry
    copy_damage_params[:image2] = base64_conversion(params[:canvas_data])
    #copy_damage_params[:image2] = base64_conversion(damage_params[:canvas_data])
    #copy_damage_params[:canvas_data] = nil

    if @damage.update(copy_damage_params)
      # 信憑性のチェック（ハッシュ値の付加）
      dst_file_path = check_credibility(@damage.image1.path)
      # 相対パスに変換
      #未使用#@damage.original_image_url = dst_file_path.match("/uploads/.*")
      @damage.original_image_url = dst_file_path
      # ハッシュ付き画像も保存
      @damage.save
      
      redirect_to check_damage_path
    else
      flash.now[:danger] = '更新に失敗しました。'
      render :edit
    end    
  end

  def check
    @damage = Damage.find(params[:id])
    @sonsyo = @damage.sonsyo
    @house = @sonsyo.house
    @investigation = @house.investigation
  end  

  def confirm
    @damage = Damage.find(params[:id])
    @sonsyo = @damage.sonsyo
    @house = @sonsyo.house
    @investigation = @house.investigation
    
    # paramsは代入できないので、コピーを生成
    copy_damage_params = damage_params    
    # canvasの画像化
    copy_damage_params[:image3] = base64_conversion(params[:canvas_data])
    @damage.update(copy_damage_params)

    # オリジナル写真のEXIF情報を取得し、ホワイトボード付き写真のEXIFに上書き
    exif1 = MiniExiftool.new(@damage.image1.path)
    exif3 = MiniExiftool.new(@damage.image3.path)
    exif3.date_time_original = exif1.date_time_original
    exif3.save

    # 信憑性のチェック（ハッシュ値の付加）
    dst_file_path = check_credibility(@damage.image3.path)
    if dst_file_path != nil
      @damage.image_url = dst_file_path
    end
    
    # ハッシュ付き画像も保存
    if @damage.save
      flash[:success] = '正常に更新されました。'
      redirect_to house_path(@house, anchor: 'sonsyo')
    else
      flash.now[:danger] = '更新に失敗しました。'
      render :confirm
    end    
  end  
  
  private

  def damage_params
    params.require(:damage).permit(:sonsyo_id, :position_wb, :genkyo, :sukima, :ware, :kake, :amimejyo, :zencho, :crack, :tile, :kire, :uki, :suhon, :zenshu,
                                  :chirigire, :cross, :meji, :tategu, :tasu, :kakusyo, :wide, :length, :width, :height, :comment,
                                  :image1, :image2, :image3, :image1_cache, :image2_cache, :image3_cache, :survey_type, :image_url, :original_image_url)
  end
end
