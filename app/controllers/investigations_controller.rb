require 'zip'
require 'csv'

class InvestigationsController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    if params[:order] == "asc"
      @investigations = Investigation.order(updated_at: :ASC) # 昇順
    elsif params[:order] == "desc"
      @investigations = Investigation.order(updated_at: :DESC) # 降順
    else
      @investigations = Investigation.order(:id) # デフォルト
    end
    
    # 検索
    unless params[:keyword].blank?
      @investigations = @investigations.where(["construction_name like?", "%#{params[:keyword]}%"])
    end
    #binding.pry
  end

  def show
    @investigation = Investigation.find(params[:id])
    @houses = @investigation.houses.order(house_number: "ASC")
    
    if request.referer == root_url
      if current_user.role != "admin" && current_user.role != "superuser"
        if @investigation.password != params[:password]
          flash[:danger] = 'パスワードが違います'
          redirect_back(fallback_location: root_path)
        end
      end
    end
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
      redirect_to @investigation
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

  def download_csv_houses
    #binding.pry
    @investigation = Investigation.find(params[:id])

    respond_to do |format|
      format.html
      format.csv do |csv|
        
        send_posts_csv_houses(@investigation)
      end
    end
  end
  def download_csv_pre
#    binding.pry
    @investigation = Investigation.find(params[:id])

    respond_to do |format|
      format.html
      format.csv do |csv|
        send_posts_csv(@investigation, "pre")
      end
    end
  end
  def download_csv_ongoing
#    binding.pry
    @investigation = Investigation.find(params[:id])

    respond_to do |format|
      format.html
      format.csv do |csv|
        send_posts_csv(@investigation, "ongoing")
      end
    end
  end 
  def download_csv_after
#    binding.pry
    @investigation = Investigation.find(params[:id])

    respond_to do |format|
      format.html
      format.csv do |csv|
        send_posts_csv(@investigation, "after")
      end
    end
  end  

  private

  # Strong Parameter
  def investigation_params
    params.require(:investigation).permit(:content, :construction_name, :construction_display_name1, :construction_display_name2, :builder, :builder_id, :place, 
                                          :investigator_pre_survey, :investigator_ongoing_survey, :investigator_after_survey,
                                          :start_pre_survey, :stop_pre_survey, :start_ongoing_survey, :stop_ongoing_survey, :start_after_survey, :stop_after_survey, :code, :password)
  end
  

  def send_posts_csv_houses(investigation)
    houses = investigation.houses.order(house_number: "ASC")

    if houses.present?
      filename = "data_houses.zip"
      fullpath = "#{Rails.root}/tmp/#{filename}"
      Zip::File.open(fullpath, Zip::File::CREATE) do |zipfile|
        # 家屋情報
        zipfile.get_output_stream("data_houses/houses.csv") do |f|
          f.puts(
            CSV.generate(encoding: Encoding::SJIS) do |csv|
              header = %w(工事コード 家屋番号 家屋名 都道府県 市区町村 番地 居住者電話番号 所有者名（フリガナ） 所有者名 都道府県（所有者） 市区町村（所有者） 番地（所有者） 所有者電話番号 構造 階数 延面積 建物が完成した日 用途 建物概要（事前） 建物概要（事中） 建物概要（事後） 調査範囲（事前） 調査範囲（事中） 調査範囲（事後） 調査日（事前） 調査日（事中） 調査日（事後）)
              csv << header
              
              houses.each do |house|
                values = [investigation.code, house.house_number, house.house_name, 
                          house.prefectures, house.city, house.block, 
                          house.resident_phone_number,
                          house.owner_name_ruby, house.owner_name, 
                          house.owner_prefectures, house.owner_city, house.owner_block,
                          house.owner_phone_number,
                          house.construction, house.floors, house.area, house.completion_date, house.use,
                          house.overview_pre_survey, house.overview_ongoing_survey, house.overview_after_survey,
                          house.range_pre_survey, house.range_ongoing_survey, house.range_after_survey,
                          house.pre_survey_day, house.ongoing_survey_day, house.after_survey_day]
                csv << values
              end
            end
          )
        end
      end
      # zipをダウンロードして、直後に削除する
      send_data File.read(fullpath), filename: filename, type: 'application/zip'
      File.delete(fullpath)
    end
  end     
        
  def send_posts_csv(investigation, survey_type)
    houses = investigation.houses.order(house_number: "ASC")
    
    if houses.present?
      st = ""
      filename = "data.zip"
      dirname = "data"
      
      if survey_type == "pre"
        st = "事前"
        filename = "data_pre.zip"
        dirname = "data_pre"
      elsif survey_type == "ongoing"
        st = "事中"
        filename = "data_ongoing.zip"
        dirname = "data_ongoing"
      elsif survey_type == "after"
        st = "事後"                        
        filename = "data_after.zip"
        dirname = "data_after"
      end
        
      fullpath = "#{Rails.root}/tmp/#{filename}"
      Zip::File.open(fullpath, Zip::File::CREATE) do |zipfile|
        # 損傷情報
        zipfile.get_output_stream(dirname + "/sonsyos.csv") do |f|
          f.puts(
            CSV.generate(encoding: Encoding::SJIS) do |csv|
              header = %w(工事コード 家屋番号 損傷番号 調査箇所 調査箇所（その他） 調査 適用 幅 長さ 横 縦 コメント)
              csv << header
              
              houses.each do |house|
                sonsyos = house.sonsyos
                if sonsyos.present?
                  sonsyos.each do |sonsyo|
                    damage = sonsyo.damages.find_by(survey_type: survey_type)
                    if damage.present?
                      values = [investigation.code, house.id, sonsyo.number, sonsyo.room_name, sonsyo.room_name_other, 
                                st, damage.tekiyo, damage.wide, damage.length, damage.width, damage.height, damage.comment]
                      csv << values              
                    end
                  end
                end
              end
            end
          )
        end
        
        # 傾斜情報
        zipfile.get_output_stream(dirname + "/keisyas.csv") do |f|
          f.puts(
            CSV.generate(encoding: Encoding::SJIS) do |csv|
              header = %w(工事コード 家屋番号 傾斜番号 調査箇所 調査箇所（その他） 調査 角度 東 西 南 北 コメント)
              csv << header
              
              houses.each do |house|
                keisyas = house.keisyas
                if keisyas.present?
                  keisyas.each do |keisya|
                    slope = keisya.slopes.find_by(survey_type: survey_type)
                    if slope.present?
                      angle = ""
                      if slope.suichokukeisya == true
                        angle = "垂直傾斜"
                      elsif slope.suichokukeisya == true
                        angle = "水平傾斜"
                      end
                      
                      values = [investigation.code, house.id, keisya.number, keisya.room_name, keisya.room_name_other, 
                                st, angle, slope.east, slope.west, slope.south, slope.north, slope.comment]
                      csv << values              
                    end
                  end
                end
              end
            end
          )
        end        
        
        # 測点（レベル）情報
        zipfile.get_output_stream(dirname + "/points.csv") do |f|
          f.puts(
            CSV.generate(encoding: Encoding::SJIS) do |csv|
              header = %w(工事コード 家屋番号 側点番号 調査箇所 調査箇所（その他） 調査 標高 往路（BS） 往路（FS） 復路（BS） 復路（FS） コメント)
              csv << header
              
              houses.each do |house|
                points = house.points
                if points.present?
                  points.each do |point|
                    post = point.posts.find_by(survey_type: survey_type)
                    if post.present?
                      values = [investigation.code, house.id, point.number, point.room_name, point.room_name_other, 
                                st, post.hyoko, post.ouro_bs, post.ouro_fs, post.fukuro_bs, post.fukuro_fs, post.comment]
                      csv << values              
                    end
                  end
                end
              end
            end
          )
        end        
        
      end
      # zipをダウンロードして、直後に削除する
      send_data File.read(fullpath), filename: filename, type: 'application/zip'
      File.delete(fullpath)
    end
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