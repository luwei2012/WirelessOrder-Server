# -*- encoding : utf-8 -*-
class WelcomeController < ApplicationController
  layout 'login'

  def index
  end

  def create
    name = params[:username]
    password = params[:password]
    if !(name.blank? || password.blank?)
      user = User.where(:name => name, :password => password).first
      if !user.blank?
        session[:user_id] = user.id
        session[:account] = user.account
        redirect_to :controller => :tables, :action => :index and return
      end
    end
    render :action => :index
  end
end
