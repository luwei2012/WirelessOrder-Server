# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token
  before_filter :check_login

  def check_login
    logger.info "user_id is #{session[:user_id]}"
    #logger.info "cookie is #{cookies.to_a}"
    #logger.info "version is#{request.env["HTTP_CVERSION"]}"
    #return if Rails.env != 'production'
    return if Rails.env != 'production'

    if not session[:user_id]
      logger.info 'session timeout OR no cookies in request'
      redirect_to :controller => :welcome, :action => :index
    end
    #if not session[:cas_user]
    #  logger.info "session timeout OR no cookies in request"
    #  redirect_to :controller => :session, :action => :index#, :port => PORT
    #end
    #if not session[:user_id]
    #    logger.info "session timeout OR no cookies in request"
    #    redirect_to :controller => :session, :action => :index#, :port => PORT
    #end
  end
end
