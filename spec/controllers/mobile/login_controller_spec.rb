# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Mobile::LoginController do
  before(:each) do
    @user = User.create! :name => 'luwei', :password => '123123', :phone => '12345678910', :role => '士大夫色弱', :account => 'luwei', :password_confirmation => '123123'
    session[:user_id] = @user.id
    session[:account]=@user.account
    session[:name]=@user.name
  end
  #describe "login" do
  it '登录成功' do
    post :sign, :account => @user.account, :password => @user.password
    result = JSON::parse(response.body)
    result['message'].should == '登陆成功！'
  end

  it '账号不存在' do
    post :sign, :account => 'admin_test', :password => @user.password
    result = JSON::parse(response.body)
    result['message'].should == '账号不存在！'
  end

  it '密码错误' do
    post :sign, :account => @user.account, :password => '111111111'
    result = JSON::parse(response.body)
    result['message'].should == '密码错误！'
  end
end
#end
