# -*- encoding : utf-8 -*-
class WelcomeController < ActionController::Base
  layout 'login'

  def index
  end

  def create
    name = params[:username]
    password = params[:password]
    if !(name.blank? || password.blank?)
      user = User.where(:account => name, :password => password).first
      if !user.blank?
        session[:user_id] = user.id
        session[:account] = user.account
        session[:role] = user.role
        redirect_to :controller => :tables, :action => :index and return
      end
    end
    render :action => :index
  end
end
