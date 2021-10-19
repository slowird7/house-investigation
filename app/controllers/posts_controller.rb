require './lib/jacic_hash_lib'
require 'mini_exiftool'
include JACICHash

class PostsController < ApplicationController
  before_action :require_user_logged_in

  def show
    @post = Post.find(params[:id])
    @point = @post.point
    @house = @point.house
    @investigation = @house.investigation
  end
  
  def edit
    @point = Point.find(params[:point_id])
    @post = @point.posts.find_by(survey_type: params[:survey_type])
    @house = @point.house
    @investigation = @house.investigation
    
    @preview_post = @point.posts.find_by(survey_type: "pre")
    if params[:survey_type] == "after"
      @preview_post = @point.posts.find_by(survey_type: "ongoing")
      unless @preview_post.image1?
        @preview_post = @point.posts.find_by(survey_type: "pre")
      end
    end
  end
  
  def update
    @post = Post.find(params[:id])
    @point = @post.point
    @house = @point.house
    @investigation = @house.investigation

    # paramsは代入できないので、コピーを生成
    copy_post_params = post_params
    # canvasの画像化
    copy_post_params[:image2] = base64_conversion(params[:canvas_data])

    if @post.update(copy_post_params)
      # 信憑性のチェック（ハッシュ値の付加）
      dst_file_path = check_credibility(@post.image1.path)
      # 相対パスに変換
      @post.original_image_url = dst_file_path
      # ハッシュ付き画像も保存
      @post.save
      
      redirect_to check_post_path
    else
      flash.now[:danger] = '更新に失敗しました。'
      render :edit
    end
  end
  
  def check
    @post = Post.find(params[:id])
    @point = @post.point
    @house = @point.house
    @investigation = @house.investigation
  end
  
  def confirm
    @post = Post.find(params[:id])
    @point = @post.point
    @house = @point.house
    @investigation = @house.investigation
    
    # paramsは代入できないので、コピーを生成
    copy_post_params = post_params    
    # canvasの画像化
    copy_post_params[:image3] = base64_conversion(params[:canvas_data])
    @post.update(copy_post_params)

    # オリジナル写真のEXIF情報を取得し、ホワイトボード付き写真のEXIFに上書き
    exif1 = MiniExiftool.new(@post.image1.path)
    exif3 = MiniExiftool.new(@post.image3.path)
    exif3.date_time_original = exif1.date_time_original
    datetime = Time.now
    exif1.date_time_original = datetime
    exif1.save
    exif3.date_time_original = datetime
    exif3.save

    # 信憑性のチェック（ハッシュ値の付加）
    dst_file_path = check_credibility(@post.image3.path)
    if dst_file_path != nil
      @post.image_url = dst_file_path
    end
    
    # ハッシュ付き画像も保存
    if @post.save
      flash[:success] = '正常に更新されました。'
      redirect_to house_path(@house, anchor: 'point')
    else
      flash.now[:danger] = '更新に失敗しました。'
      render :confirm
    end    
  end  
  
  private

  def post_params
    params.require(:post).permit(:point_id, :position_wb, :comment, :image1, :image2, :image3, :image1_cache, :image2_cache, :image3_cache, 
                                 :survey_type, :image_url, :ouro_bs, :ouro_fs, :fukuro_bs, :fukuro_fs, :hyoko)
  end
end
