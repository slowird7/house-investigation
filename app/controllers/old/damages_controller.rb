require './lib/jacic_hash_lib'
require 'mini_exiftool'
include JACICHash

class DamagesController < ApplicationController
  before_action :require_user_logged_in  
  
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

    tmp_damage_params = damage_params

    if tmp_damage_params[:original_image_url] != nil
      # image（矢印なし（プレーン））を更新
      imgData = base64_conversion(tmp_damage_params[:original_image_url])
      
      # オリジナル画像から撮影日時を抜き出す
      photo = MiniExiftool.new(nohash_img_file.path)
      date_time_original = photo.date_time_original
      
      image_data = uploadfile(imgData)
#      image_data = base64_conversion_hash(tmp_damage_params[:original_image_url])
      tmp_damage_params[:image2] = image_data
      tmp_damage_params[:original_image_url] = nil
    end

    # image（矢印あり）を更新
    imgData = base64_conversion_hash(tmp_damage_params[:original_image_url], date_time_original)
    image_data = uploadfile(imgData)
#    image_data = base64_conversion(tmp_damage_params[:image_url])    
#    image_data = base64_conversion_hash(tmp_damage_params[:image_url])
    tmp_damage_params[:image1] = image_data
    tmp_damage_params[:image_url] = nil

    if @damage.update(tmp_damage_params)
      # 初期化
      @damage.image3 = nil
      @damage.save
      
      # 調査開始日・終了日の更新
      if @damage.survey_type == "pre"
        if @investigation.start_pre_survey == nil
          @investigation.start_pre_survey = Date.today
        end
        @investigation.stop_pre_survey = Date.today
      elsif @damage.survey_type == "ongoing"
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

      #flash[:success] = '正常に更新されました。'
      
      #redirect_to @house
      #redirect_to house_path(@house, anchor: 'sonsyo')
      
      #binding.pry
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
    
    image_data = base64_conversion(damage_params[:image_url])
#    image_data = base64_conversion_hash(damage_params[:image_url])
    @damage.image3 = image_data;
    
    if @damage.save
#      srcFilePath = "https://8930bcc56fe24ff489d30b72154fb63d.vfs.cloud9.us-east-1.amazonaws.com" + @damage.image3.url
#      dstFilePath = "https://8930bcc56fe24ff489d30b72154fb63d.vfs.cloud9.us-east-1.amazonaws.com" + @damage.image1.url

#      srcFilePath = "tmp/48c4650b-aa28-4660-bb4f-f1dbc8c22982.jpg"
#      srcFilePath = "public" + @damage.image3.url
#      dstFilePath = "tmp/test.jpg"
#      dstFilePath = "tmp/test.jpg"
      
#      ret = JACICHash.writeHash(srcFilePath, dstFilePath)
#      ret = JACICHash.writeHash("tmp/src.jpg", "tmp/dst.jpg")
#      if ret != 0
        # エラー処理
#        binding.pry
#        raise
#      end

#      ret = JACICHash.checkHash(dstFilePath)
#      if ret != 1
#        binding.pry
        # エラー処理
#        raise
#      end

#      binding.pry

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

  class ImageData
    def initialize()
      @image_data = nil
      @tmp_img_file = nil
    end
    attr_accessor :image_data
    attr_accessor :tmp_img_file
  end

  def base64_conversion(uri_str, filename = 'base64')
    image_data = split_base64(uri_str)
    image_data_string = image_data[:data]
    image_data_binary = Base64.decode64(image_data_string)

    temp_img_file = Tempfile.new(filename)
    temp_img_file.binmode
    temp_img_file << image_data_binary
    temp_img_file.rewind
    
    ret = ImageData.new
    ret.image_data = image_date
    ret.tmp_img_file = tmp_img_file
    return ret
  end

  def uploadfile(imgData)
    img_params = {:filename => "#{filename}.#{imgData.image_data[:extension]}", :type => imgData.image_data[:type], :tempfile => imgData.temp_img_file}
    #img_params = {:filename => "#{filename}.jpg", :type => "image/jpg", :tempfile => temp_img_file}
    ActionDispatch::Http::UploadedFile.new(img_params)
  end
    
#  def base64_conversion(uri_str, filename = 'base64')
    #image_data = split_base64(uri_str)
    #image_data_string = image_data[:data]
    #image_data_binary = Base64.decode64(image_data_string)

    #temp_img_file = Tempfile.new(filename)
    #temp_img_file.binmode
    #temp_img_file << image_data_binary
    #temp_img_file.rewind

    #img_params = {:filename => "#{filename}.#{image_data[:extension]}", :type => image_data[:type], :tempfile => temp_img_file}
    #img_params = {:filename => "#{filename}.jpg", :type => "image/jpg", :tempfile => temp_img_file}
    #ActionDispatch::Http::UploadedFile.new(img_params)
  #end

  def base64_conversion_hash(uri_str, date_time_original, filename = 'base64')
    image_data = split_base64(uri_str)
    image_data_string = image_data[:data]
    image_data_binary = Base64.decode64(image_data_string)

    nohash_filename = "#{filename}_nohash"
    nohash_img_file = Tempfile.new(nohash_filename)
    nohash_img_file.binmode
    nohash_img_file << image_data_binary
    nohash_img_file.rewind
    
    # 撮影日時を追加する
    photo = MiniExiftool.new(nohash_img_file.path)
    photo.date_time_original = date_time_original
    photo.save
    
    # ハッシュ付きJPEGのパス
    dst_file_path = File.join(File.dirname(nohash_img_file.path), File.basename(nohash_img_file.path).gsub("#{filename}_nohash", "#{filename}_hash"))

    # ハッシュを付加する
    ret = JACICHash.writeHash(nohash_img_file.path, dst_file_path)
    puts "writeHash ret=#{ret}"
    if ret != 0
      # エラー処理
      raise
    end

    ret = JACICHash.checkHash(dst_file_path)
    puts "checkHash ret=#{ret}"
    if ret != 1
      # エラー処理
      raise
    end
    
    # ハッシュ付きJPEGをテンポラリファイルにコピー
    hash_img_file = Tempfile.new(filename)
    hash_img_file.binmode
    hash_img_file << File.binread(dst_file_path)
    hash_img_file.rewind
    
    # 元のハッシュ付きJPEGは削除する
    File.delete(dst_file_path)

    ret = ImageData.new
    ret.image_data = image_date
    ret.tmp_img_file = tmp_img_file
    return ret
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
