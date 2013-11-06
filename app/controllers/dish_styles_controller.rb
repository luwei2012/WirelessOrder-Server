# -*- encoding : utf-8 -*-
class DishStylesController < ApplicationController
  layout 'dish_style'
  before_action :set_dish_style, only: [:show, :edit, :update, :destroy]

  def index
    page=params[:page] ? params[:page].to_i : 1
    page_size = params[:page_size] ? params[:page_size].to_i : 15
    @list = DishStyle.order('id desc').paginate(:page => page, :per_page => page_size)
  end


# GET /dishes/1
# GET /dishes/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dish_style }
    end
  end

# GET /dishes/new
  def new
    @dish_style = DishStyle.new
  end

# GET /dishes/1/edit
  def edit

  end

# POST /dishes
# POST /dishes.json
  def create
    @dish_style = DishStyle.new()

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
      format.html { redirect_to dish_styles_url }
      format.json { head :no_content }
    end
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
