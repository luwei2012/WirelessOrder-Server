# -*- encoding : utf-8 -*-
class AuthoritiesController < ApplicationController
  def index
    role_id = params[:role_id] ? params[:role_id].to_i : -1
    page = params[:page] ? params[:page].to_i : 1
    page_size = params[:page_size] ? params[:page_size].to_i : 15
    if role_id==-1
      @list = User.order('created_at desc').paginate(:page => page, :per_page => page_size)
    else
      @list = User.where(:role => ROLE_NAME[role_id]).order('created_at desc').paginate(:page => page, :per_page => page_size)
    end
  end


  def show
    @user = User.find params[:id]
  end

  def destroy
    @user = User.find params[:id]

    @user.destroy
    redirect_to :action => :index

  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    @user.account = params[:user][:account]
    @user.role = params[:user][:role] ? params[:user][:role] : '普通用户'
    @user.phone = params[:user][:phone]
    password = params[:user][:new_password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if password.blank?
      @user.password = params[:user][:old_password]
      @user.password_confirmation = params[:user][:old_password]
    else
      @user.password = password
    end
    user = User.find_by_account @user.account
    if user && user.id != @user.id
      flash[:msg] = '该用户名已被占用'
      @user.password = params[:user][:old_password]
      render :edit and return

    else

      begin
        User.transaction do
          @user.save!

          flash[:notice] = '修改成功'
          redirect_to :action => :show, :id => @user.id
        end
      rescue
        error_message = ''
        @user.errors[:error_message].each do |error|
          if error == @user.errors[:error_message].last
            error_message += error.to_s
          else
            error_message += error.to_s + ','
          end
        end
        flash[:msg] = error_message
        @user.errors.clear
        @user.password = params[:user][:old_password]
        render :edit and return

      end
    end

  end

  def new
    @user = User.new
  end

  def create
    @user = User.new
    @user.name = params[:user][:name]
    @user.account = params[:user][:account]
    @user.password = params[:user][:password]
    @user.phone = params[:user][:phone]
    @user.role = params[:user][:role] ? params[:user][:role] : '普通用户'
    @user.password_confirmation = params[:user][:password_confirmation]
    user = User.find_by_account @user.account

    if user
      flash[:msg] = '该账号已被占用'
      render :new and return

    else

      begin
        User.transaction do
          @user.save!
          flash[:notice] = '创建新用户成功'
          redirect_to :action => :index
        end

      rescue
        error_message = ''
        @user.errors[:error_message].each do |error|
          if error == @user.errors[:error_message].last
            error_message += error.to_s
          else
            error_message += error.to_s + ','
          end
        end
        flash[:msg] = error_message
        @user.errors.clear
        render :new and return
      end
    end
  end


  def logout
    reset_session
    redirect_to :controller => :welcome, :action => :index and return
  end

end

