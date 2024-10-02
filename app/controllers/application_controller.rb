require './lib/jacic_hash_lib'
require 'mini_exiftool'
#require 'aws-sdk'
#require 'exifr/jpeg'
include JACICHash

class ApplicationController < ActionController::Base
  #protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
 
  include SessionsHelper
 
  private

  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
  
  # 調査日の更新
  def update_survey_day(house, target)
    if target.survey_type == "pre"
      if house.pre_survey_day == nil
        # 調査開始日
        house.pre_survey_day = target.created_at
      else
        # 調査終了日
        house.end_pre_survey_day = target.created_at
      end
    elsif target.survey_type == "ongoing"
      if house.ongoing_survey_day == nil
        # 調査開始日
        house.ongoing_survey_day = target.created_at
      else
        # 調査終了日
        house.end_ongoing_survey_day = target.created_at
      end
    elsif target.survey_type == "after"      
      if house.after_survey_day == nil
        # 調査開始日
        house.after_survey_day = target.created_at
      else
        # 調査終了日
        house.end_after_survey_day = target.created_at
      end      
    end
    
    if house.save
      return true
    else
      return false
    end
  end
  
  
  # # # # # # # # # # 改ざん防止メソッド # # # # # # # # # #
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
    #binding.pry
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
  
  def check_credibility(image_path)
    # ハッシュ付き画像パスの生成
    #dst_file_path = File.join(File.dirname(image_path), File.basename(image_path, '.*') + "_hash" + File.extname(image_path))
    dst_file_path = File.join(File.dirname(image_path), File.basename(image_path, '.*') + "_hash" + ".jpg")

    # ハッシュを付加した画像の生成
    ret = JACICHash.writeHash(image_path, dst_file_path)
    puts "writeHash ret=#{ret}"
    if ret != 0
      # エラー
      return nil
    end

    # ハッシュのチェック
    ret = JACICHash.checkHash(dst_file_path)
    puts "checkHash ret=#{ret}"
    if ret != 1
      # エラー
      return nil
    end
    
    # ハッシュ付き画像のパスを返却
    return dst_file_path
  end
end
