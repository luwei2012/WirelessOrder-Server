# -*- encoding : utf-8 -*-
class DishesController < ApplicationController
  before_action :set_dish, only: [:show, :edit, :update, :destroy]
  before_action :set_dish_style_and_type, only: [:index, :show, :new, :edit]
  # GET /dishes
  # GET /dishes.json
  def index
    if session[:dish_style].blank?
      session[:dish_style]=-1
    end
    if session[:dish_type].blank?
      session[:dish_type]=-1
    end
    page=params[:page] ? params[:page].to_i : 1
    page_size = params[:page_size] ? params[:page_size].to_i : 15
    if @type_list.blank? || @style_list.blank?
      if !@type_list.blank?
        session[:dish_type]= @type_list[0].id
      end
      @list = []
    elsif session[:dish_style]==-1 && session[:dish_type]==-1
      session[:dish_type]= @type_list[0].id
      @list = @type_list[0].dishes.order('id desc').paginate(:page => page, :per_page => page_size)
    elsif session[:dish_style]==-1 && session[:dish_type]!=-1
      @list = DishType.find_by_id(session[:dish_type]).dishes.order('id desc').paginate(:page => page, :per_page => page_size)
    elsif session[:dish_style]!=-1 && session[:dish_type]==-1
      session[:dish_type]= @type_list[0].id
      @list = @type_list[0].dishes.where("dish_style_id = #{session[:dish_style]}").order('id desc').paginate(:page => page, :per_page => page_size)
    else
      @list = DishType.find_by_id(session[:dish_type]).dishes.where("dish_style_id = #{session[:dish_style]}").order('id desc').paginate(:page => page, :per_page => page_size)
    end

  end


# GET /dishes/1
# GET /dishes/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dish }
    end
  end

# GET /dishes/new
  def new
    @dish = DishType.find_by_id(session[:dish_type]).dishes.new
    if (!session[:dish_style].blank?) && session[:dish_style]!=-1
      @dish.dish_style_id=session[:dish_style]
    end

  end

# GET /dishes/1/edit
  def edit

  end

# POST /dishes
# POST /dishes.json
  def create
    @dish = Dish.new()
    @dish.name = params[:dish][:name]
    @dish.dish_type_id = params[:dish][:dish_type_id].to_i
    @dish.dish_style_id = params[:dish][:dish_style_id].to_i
    @dish.price = params[:dish][:price].to_i
    @dish.cost_time = params[:dish][:cost_time].to_i
    @dish.remarks = params[:dish][:remarks]
    @dish.sales= params[:dish][:sales] ? params[:dish][:sales].to_f : 1.0
    @dish.imageUrl = params[:dish][:imageUrl]
    @dish.status = params[:dish][:status] ? params[:dish][:status].to_i : 1
    @dish.count = params[:dish][:count] ? params[:dish][:count].to_i : 0

    begin
      Dish.transaction do
        @dish.save!
        flash[:notice] = '创建菜品成功'
      end
      redirect_to :action => :index

    rescue
      error_message = ''
      @dish.errors[:error_message].each do |error|
        if error == @dish.errors[:error_message].last
          error_message += error.to_s
        else
          error_message += error.to_s + ','
        end
      end
      flash[:msg] = error_message
      @dish.errors.clear
      render :new and return

    end

  end

# PATCH/PUT /dishes/1
# PATCH/PUT /dishes/1.json
  def update
    @dish.name = params[:dish][:name]
    @dish.dish_type_id = params[:dish][:dish_type_id].to_i
    @dish.dish_style_id = params[:dish][:dish_style_id].to_i
    @dish.price = params[:dish][:price].to_i
    @dish.cost_time = params[:dish][:cost_time].to_i
    @dish.remarks = params[:dish][:remarks]
    @dish.imageUrl = params[:dish][:imageUrl]
    @dish.sales= params[:dish][:sales] ? params[:dish][:sales].to_f : 1.0
    @dish.status = params[:dish][:status] ? params[:dish][:status].to_i : 1
    @dish.count = params[:dish][:count] ? params[:dish][:count].to_i : 0

    begin
      Dish.transaction do
        @dish.save!
        flash[:notice] = '修改菜品成功'
      end
      redirect_to :action => :show, :id => @dish.id #, :port => PORT
    rescue
      error_message = ''
      @dish.errors[:error_message].each do |error|
        if error == @dish.errors[:error_message].last
          error_message += error.to_s
        else
          error_message += error.to_s + ','
        end
      end
      flash[:msg] = error_message
      @dish.errors.clear
      render :edit and return

    end
  end

# DELETE /dishes/1
# DELETE /dishes/1.json
  def destroy
    @dish.destroy
    respond_to do |format|
      format.html { redirect_to dishes_url }
      format.json { head :no_content }
    end
  end

  def select_type
    session[:dish_type] = params[:type] ? params[:type].to_i : -1
    render :json => {result: :success}
  end

  def select_style
    session[:dish_style] = params[:style_id] ? params[:style_id].to_i : -1
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
  def set_dish
    @dish = Dish.find(params[:id])
  end

  def set_dish_style_and_type
    if @type_list.blank?
      @type_list=DishType.order('id desc')
    end
    if @style_list.blank?
      @style_list=DishStyle.order('id desc')
    end
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def dish_params
    params[:dish]
  end


end
