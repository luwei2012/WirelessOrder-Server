# -*- encoding : utf-8 -*-
class Mobile::MoblieController < ActionController::Base
  protect_from_forgery

  skip_before_filter :verify_authenticity_token
  #before_filter :check_version
  before_filter :check_login

  def check_login
    logger.info "user_id is #{session[:user_id]}"
    #logger.info "cookie is #{cookies.to_a}"
    #logger.info "version is#{request.env["HTTP_CVERSION"]}"
    #return if Rails.env != 'production'
    return if Rails.env != 'production'

    if not session[:user_id]
      logger.info 'session timeout OR no cookies in request'
      render :json => {:session => 'timeout'}.to_json,:status => ERROR[:normal] and return
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
