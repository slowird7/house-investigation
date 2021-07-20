require './lib/jacic_hash_lib'
require 'mini_exiftool'
require 'aws-sdk-s3'
#require 'aws-sdk'
#require 'exifr/jpeg'
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
    copy_damage_params[:image2] = base64_conversion(params[:canvas_data])
    #puts 'damage_controller.update>'
    #debugger
    if @damage.update(copy_damage_params)
      # 信憑性のチェック（ハッシュ値の付加）
      if Rails.env.development?
        dst_file_path = check_credibility(@damage.image1.path)
      else
        dst_file_path = check_credibility(@damage.image1.path)
#        dst_file_path = check_credibility(download_image(@damage.image1.path))
#        dst_file_path = File.join(File.dirname(@damage.image1.path), File.basename(@damage.image1.path, '.*') + "_hash" + ".jpg")
      end
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
    #puts 'damage_controller.confirm>'
    #debugger
    # オリジナル写真のEXIF情報を取得し、ホワイトボード付き写真のEXIFに上書き
  #[ n_otsuka
  #  p sprintf("@damage.image1.path=%s¥n", @damage.image1.path)
  #  p sprintf("full path=%s¥n", File::expand_path(@damage.image1.path))
    #p sprintf("@damage.image1_cache.path=%s¥n", File::expand_path(@damage.image1_cache.path))
    
  #] 
    if Rails.env.development?
      exif1 = MiniExiftool.new(@damage.image1.path)
      exif3 = MiniExiftool.new(@damage.image3.path) 
    else 
      exif1 = MiniExiftool.new(@damage.image1.path)
      exif3 = MiniExiftool.new(@damage.image3.path) 
#      exif1 = MiniExiftool.new(download_image(@damage.image1.path))
#      exif3 = MiniExiftool.new(download_image(@damage.image3.path)) 
    end      
#    byebug
#[ 2021.07.21 n_otsuka
#    exif3.date_time_original = exif1.date_time_original
#    exif3.save
    datetime = Time.now
    exif1.date_time_original = datetime
    exif1.save
    exif3.date_time_original = datetime
    exif3.save

    # 信憑性のチェック（ハッシュ値の付加）
    if Rails.env.development?
      dst_file_path = check_credibility(@damage.image3.path)
    else 
      dst_file_path = check_credibility(@damage.image3.path)
 #     dst_file_path = check_credibility(download_image(@damage.image3.path))
#      dst_file_path = File.join(File.dirname(@damage.image3.path), File.basename(@damage.image3.path, '.*') + "_hash" + ".jpg")
    end
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
    params.require(:damage).permit(:tekiyo, :sonsyo_id, :position_wb, :genkyo, :sukima, :ware, :kake, :amimejyo, :zencho, :crack, :tile, :kire, :uki, :suhon, :zenshu,
                                  :chirigire, :cross, :meji, :tategu, :tasu, :kakusyo, :wide, :length, :width, :height, :comment,
                                  :image1, :image2, :image3, :image1_cache, :image2_cache, :image3_cache, :survey_type, :image_url, :original_image_url)
  end

  def download_image(image_path)
    
    # cf. https://noteblog.net/ruby-on-rails-s3-download-file/
    
    
    #bucket_name = 'doc-example-bucket'
    #object_key = 'my-file.txt'
    #object_content = 'This is the content of my-file.txt.'
    #target_bucket_name = 'doc-example-bucket1'
    #target_object_key = 'my-file-1.txt'
    #region = ENV["AWS_DEFAULT_REGION"]
    s3_client = Aws::S3::Client.new(region: ENV["AWS_DEFAULT_REGION"])

    #debugger
    
    # 一旦サーバーに保存してからローカルにダウンロードさせる、access_key_id, secret_access_keyでアクセスさせたいため
    # ファイルの削除はherokuの場合自動でやらせる
    tmpfile = File.basename(image_path, '.*') + ".jpg"
    if !File.exist?("#{Rails.root}/imagetmp/#{tmpfile}")
#      s3.bucket(ENV["AWS_BUCKET"]).object(image).get(response_target: "#{Rails.root}/imagetmp/#{image}")
      s3_client.get_object(
        response_target: "#{Rails.root}/imagetmp/#{tmpfile}",
        bucket: ENV['AWS_BUCKET'],
        key: image_path
      )
    end
   
    return "#{Rails.root}/imagetmp/#{tmpfile}"
#    send_file "#{Rails.root}/imagetmp/#{@photo.image_id}.#{extension}", x_sendfile: true
  end 

  # Downloads an object from an Amazon Simple Storage Service (Amazon S3) bucket.
  #
  # @param s3_client [Aws::S3::Client] An initialized S3 client.
  # @param bucket_name [String] The name of the bucket containing the object.
  # @param object_key [String] The name of the object to download.
  # @param local_path [String] The path on your local computer to download
  #   the object.
  # @return [Boolean] true if the object was downloaded; otherwise, false.
  # @example
  #   exit 1 unless object_downloaded?(
  #     Aws::S3::Client.new(region: 'us-east-1'),
  #     'doc-example-bucket',
  #     'my-file.txt',
  #     './my-file.txt'
  #   )
  def object_downloaded?(s3_client, bucket_name, object_key, local_path)
    s3_client.get_object(
      response_target: local_path,
      bucket: bucket_name,
      key: object_key
    )
  rescue StandardError => e
    puts "Error getting object: #{e.message}"
  end

end
