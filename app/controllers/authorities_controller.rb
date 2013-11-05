# -*- encoding : utf-8 -*-
class AuthoritiesController < ApplicationController
  def index

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
    @user.name = params[:user][:username]
    @user.account = params[:user][:email]
    @user.password = params[:user][:password]
    @user.phone = params[:user][:telephone]
    @user.password_confirmation = params[:user][:password_confirmation]
    user = User.find_by_username @user.account

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

