# -*- encoding : utf-8 -*-
class TablesController < ApplicationController

  def index
    if session[:table_type].blank?
      session[:table_type]=-1
    end
    page=params[:page] ? params[:page].to_i : 1
    page_size = params[:page_size] ? params[:page_size].to_i : 15
    if   session[:table_type] == -1
      @list = Table.order('number ASC').paginate(:page => page, :per_page => page_size)
    else
      @list = Table.where("status = #{session[:table_type]}").order('number ASC').paginate(:page => page, :per_page => page_size)
    end
  end


  # GET /coupons/1
  # GET /coupons/1.json
  def show
    @table = Table.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @table }
    end
  end

  # GET /coupons/new
  # GET /coupons/new.json
  def new
    @table = Table.new
    if Table.last.blank?
      @table.number = 1
    else
      @table.number = Table.last.number+1
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @table }
    end
  end

  # GET /coupons/1/edit
  def edit
    @table = Table.find(params[:id])
  end

  # POST /coupons
  # POST /coupons.json

  #t.integer  "number"
  #t.integer  "size"
  #t.integer  "status"
  #t.string   "name"
  #t.datetime "created_at"
  #t.datetime "updated_at"

  def create
    @table = Table.new
    @table.number = params[:table][:number].to_i
    @table.size = params[:table][:size].to_i
    @table.status = 0
    @table.name = params[:table][:name]


    begin
      Table.transaction do
        @table.save!
        flash[:notice] = '创建餐桌成功'
      end
      redirect_to :action => :index

    rescue
      error_message = ''
      @table.errors[:error_message].each do |error|
        if error == @table.errors[:error_message].last
          error_message += error.to_s
        else
          error_message += error.to_s + ','
        end
      end
      flash[:msg] = error_message
      @table.errors.clear
      render :new and return

    end

  end

  # PUT /coupons/1
  # PUT /coupons/1.json
  def update

    @table = Table.find(params[:id])

    @table.number = params[:table][:number].to_i
    @table.size = params[:table][:size].to_i
    @table.status = params[:table][:status].to_i
    @table.name = params[:table][:name]

    begin
      Table.transaction do
        @table.save!
        flash[:notice] = '修改餐桌成功'


      end
      redirect_to :action => :show, :id => @table.id #, :port => PORT
    rescue
      error_message = ''
      @table.errors[:error_message].each do |error|
        if error == @table.errors[:error_message].last
          error_message += error.to_s
        else
          error_message += error.to_s + ','
        end
      end
      flash[:msg] = error_message
      @table.errors.clear
      render :edit and return

    end

  end

  # DELETE /coupons/1
  # DELETE /coupons/1.json
  def destroy
    @table = Table.find(params[:id])
    @table.destroy

    respond_to do |format|
      format.html { redirect_to tables_url }
      format.json { head :no_content }
    end
  end

  def select_type
    session[:table_type] = params[:type].to_i
    render :json => {result: :success}
  end
end
