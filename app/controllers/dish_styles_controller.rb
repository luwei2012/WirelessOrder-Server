class DishStylesController < ApplicationController
  before_action :set_dish_style, only: [:show, :edit, :update, :destroy]
  def index
    if @type_list.blank?
      @type_list=DishType.all
    end
    if session[:dish_type].blank?
      session[:dish_type]=0
    end
    page=params[:page] ? params[:page].to_i : 1
    page_size = params[:page_size] ? params[:page_size].to_i : 15
    @list = DishStyle.order('id desc').paginate(:page => page, :per_page => page_size)
  end


# GET /dishes/1
# GET /dishes/1.json
  def show
    if @type_list.blank?
      @type_list=DishType.all
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dish_style }
    end
  end

# GET /dishes/new
  def new
    if @type_list.blank?
      @type_list=DishType.all
    end
    @dish_style = DishStyle.new
  end

# GET /dishes/1/edit
  def edit
    if @type_list.blank?
      @type_list=DishType.all
    end
  end

# POST /dishes
# POST /dishes.json
  def create
    @dish_style = DishStyle.new()
    if @type_list.blank?
      @type_list=DishType.all
    end
    #t.string   "name"
    #t.string   "describe"
    #t.datetime "created_at"
    #t.datetime "updated_at"
    @dish_style.name = params[:dish_style][:name]
    @dish_style.describe = params[:dish_style][:describe]

    begin
      DishStyle.transaction do
        @dish_style.save!
        flash[:notice] = '创建菜系成功'
      end
      redirect_to :action => :index

    rescue
      error_message = ''
      @dish_style.errors[:error_message].each do |error|
        if error == @dish_style.errors[:error_message].last
          error_message += error.to_s
        else
          error_message += error.to_s + ','
        end
      end
      flash[:msg] = error_message
      @dish_style.errors.clear
      render :new and return
    end

  end

# PATCH/PUT /dishes/1
# PATCH/PUT /dishes/1.json
  def update
    @dish_style = DishStyle.find(params[:id])
    if @type_list.blank?
      @type_list=DishType.all
    end
    @dish_style.name = params[:dish_style][:name]
    @dish_style.describe = params[:dish_style][:describe]

    begin
      DishStyle.transaction do
        @dish_style.save!
        flash[:notice] = '修改菜系成功'
      end
      redirect_to :action => :show, :id => @dish_style.id #, :port => PORT
    rescue
      error_message = ''
      @dish_style.errors[:error_message].each do |error|
        if error == @dish_style.errors[:error_message].last
          error_message += error.to_s
        else
          error_message += error.to_s + ','
        end
      end
      flash[:msg] = error_message
      @dish_style.errors.clear
      render :edit and return

    end
  end

# DELETE /dishes/1
# DELETE /dishes/1.json
  def destroy
    @dish_style.destroy
    respond_to do |format|
      format.html { redirect_to dishes_url }
      format.json { head :no_content }
    end
  end

  def select_type
    session[:dish_type] = params[:type].to_i
    render :json => {result: :success}
  end

  def image_upload
    image_upload=params[:file_upload]
    file_extname = File.extname image_upload.original_filename
    new_file_name = "#{Time.now.strftime('%Y%m%d%H%M%S')}#{session[:user_id]}#{file_extname}"
    folder_path = "/image_uploads/#{Time.now.strftime('%Y') }/#{Time.now.strftime('%m')}/"
    url_path = folder_path + new_file_name
    full_folder_path = "#{Rails.root.to_s}/public#{folder_path}"
    new_file_path = "#{Rails.root.to_s}/public#{url_path}"
    unless File.exist? full_folder_path
      `mkdir -p #{full_folder_path}`
    end
    if !image_upload.original_filename.empty?
      File.open(new_file_path, 'wb') do |f|
        f.write(image_upload.read)
        f.close
      end
    end

    #转换格式生成缩略图
    #中图路径
    middle_url_thumbnail_path = url_path.gsub(file_extname, "-M#{file_extname}")
    middle_thumbnail_path = new_file_path.gsub(file_extname, "-M#{file_extname}")
    #小图路径
    small_thumbnail_path = new_file_path.gsub(file_extname, "-S#{file_extname}")
    #begin
    %x(convert -resize #{THUMBNAIL_SIZE.middle_width}x#{THUMBNAIL_SIZE.middle_height} #{new_file_path} #{middle_thumbnail_path})
    %x(convert -resize #{THUMBNAIL_SIZE.small_width}x#{THUMBNAIL_SIZE.small_height} #{new_file_path} #{small_thumbnail_path})
    #rescue =>ex
    #
    #end
    image_path_hash = {'image_path' => middle_url_thumbnail_path}

    render :json => image_path_hash.to_json, :content_type => 'text/html'
  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_dish_style
    @dish_style= DishStyle.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def dish_params
    params[:dish_style]
  end

end
