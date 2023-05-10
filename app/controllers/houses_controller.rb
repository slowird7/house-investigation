class HousesController < ApplicationController
  before_action :require_user_logged_in
  
  def new
    @investigation = Investigation.find(params[:investigation_id])
    @house = @investigation.houses.build
  end

  def create
    @investigation = Investigation.find(house_params[:investigation_id])
    @house = @investigation.houses.build(house_params)
    
    if @house.save
      flash[:success] = '正常に家屋を登録しました。'
      redirect_to @investigation
    else
      @houses = @investigation.houses.order('created_at DESC')
      flash.now[:danger] = '失敗しました。'
      render :new
    end    
  end

  def show
    @house = House.find(params[:id])
    @investigation = @house.investigation
    @points = @house.points
    @sonsyos = @house.sonsyos
    @keisyas = @house.keisyas
  end
  
  def edit
    @house = House.find(params[:id])
    @investigation = @house.investigation    
  end

  def update
    @house = House.find(params[:id])
    tmp_house_params = house_params
    
    #binding.pry
    
    if tmp_house_params[:sign_pre_survey] != nil
      image_data = base64_conversion(tmp_house_params[:sign_pre_survey])
      tmp_house_params[:sign_pre_survey] = image_data
    end
    if tmp_house_params[:sign_ongoing_survey] != nil 
      image_data = base64_conversion(tmp_house_params[:sign_ongoing_survey])
      tmp_house_params[:sign_ongoing_survey] = image_data
    end
    if tmp_house_params[:sign_after_survey] != nil 
      image_data = base64_conversion(tmp_house_params[:sign_after_survey])
      tmp_house_params[:sign_after_survey] = image_data
    end
    
    if tmp_house_params[:kyojyusya_sign_pre_survey] != nil
      image_data = base64_conversion(tmp_house_params[:kyojyusya_sign_pre_survey])
      tmp_house_params[:kyojyusya_sign_pre_survey] = image_data
    end  
    if tmp_house_params[:kyojyusya_sign_ongoing_survey] != nil 
      image_data = base64_conversion(tmp_house_params[:kyojyusya_sign_ongoing_survey])
      tmp_house_params[:kyojyusya_sign_ongoing_survey] = image_data
    end
    if tmp_house_params[:kyojyusya_sign_after_survey] != nil 
      image_data = base64_conversion(tmp_house_params[:kyojyusya_sign_after_survey])
      tmp_house_params[:kyojyusya_sign_after_survey] = image_data
    end
      
    if @house.update(tmp_house_params)
      flash[:success] = '正常に更新されました。'
      redirect_to @house
    else
      flash.now[:danger] = '更新に失敗しました。'
      render :edit
    end     
  end

  def destroy
    @house = House.find(params[:id])
    @investigation = @house.investigation
    @house.destroy

    flash[:success] = '正常に削除されました'
    redirect_to @investigation
  end
  
  #########################################################  
  # 所有者の承諾書
  def syodakusyo_new_pre_survey
    @house = House.find(params[:id])
    @investigation = @house.investigation
  end
  def syodakusyo_new_ongoing_survey
    @house = House.find(params[:id])
    @investigation = @house.investigation
  end
  def syodakusyo_new_after_survey
    @house = House.find(params[:id])
    @investigation = @house.investigation
  end
  
  def syodakusyo_show_pre_survey
    @house = House.find(params[:id])
    @investigation = @house.investigation
  end
  def syodakusyo_show_ongoing_survey
    @house = House.find(params[:id])
    @investigation = @house.investigation
  end
  def syodakusyo_show_after_survey
    @house = House.find(params[:id])
    @investigation = @house.investigation
  end

  #########################################################  
  # 居住者の承諾書
  def kyojyusya_syodakusyo_new_pre_survey
    @house = House.find(params[:id])
    @investigation = @house.investigation
  end
  def kyojyusya_syodakusyo_new_ongoing_survey
    @house = House.find(params[:id])
    @investigation = @house.investigation
  end
  def kyojyusya_syodakusyo_new_after_survey
    @house = House.find(params[:id])
    @investigation = @house.investigation
  end
  
  def kyojyusya_syodakusyo_show_pre_survey
    @house = House.find(params[:id])
    @investigation = @house.investigation
  end
  def kyojyusya_syodakusyo_show_ongoing_survey
    @house = House.find(params[:id])
    @investigation = @house.investigation
  end
  def kyojyusya_syodakusyo_show_after_survey
    @house = House.find(params[:id])
    @investigation = @house.investigation
  end
  
  private

  def house_params
    params.require(:house).permit(:investigation_id, :house_number, :house_name, :prefectures, :city, :block, :resident_phone_number, 
                                  :owner_name_ruby, :owner_name, :owner_prefectures, :owner_city, :owner_block, :owner_phone_number,
                                  :construction, :floors, :area, :use, 
                                  :overview_pre_survey, :range_pre_survey, :overview_ongoing_survey, :range_ongoing_survey, :overview_after_survey, :range_after_survey,
                                  :sign_pre_survey, :sign_ongoing_survey, :sign_after_survey, 
                                  :kyojyusya_sign_pre_survey, :kyojyusya_sign_ongoing_survey, :kyojyusya_sign_after_survey,
                                  :pre_survey_day, :ongoing_survey_day, :after_survey_day, :completion_date)
  end  
  
### application_controller.rbに移行 ###  
#  def base64_conversion(uri_str, filename = 'base64')
#    image_data = split_base64(uri_str)
#    image_data_string = image_data[:data]
#    image_data_binary = Base64.decode64(image_data_string)

#    temp_img_file = Tempfile.new(filename)
#    temp_img_file.binmode
#    temp_img_file << image_data_binary
#    temp_img_file.rewind

#    img_params = {:filename => "#{filename}.#{image_data[:extension]}", :type => image_data[:type], :tempfile => temp_img_file}
#    ActionDispatch::Http::UploadedFile.new(img_params)
#  end

#  def split_base64(uri_str)
#    if uri_str.match(%r{data:(.*?);(.*?),(.*)$})
#      uri = Hash.new
#      uri[:type] = $1
#      uri[:encoder] = $2
#      uri[:data] = $3
#      uri[:extension] = $1.split('/')[1]
#      return uri
#    else
#      return nil
#    end
#  end  
end