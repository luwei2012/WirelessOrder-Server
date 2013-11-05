# -*- encoding : utf-8 -*-
class Mobile::LoginController < Mobile::MoblieController

  def sign
    account = params[:account]
    password = params[:password]

    if !(account.blank? || password.blank?)
      user = User.find_by_account(account)

      if (!user.blank?)
        if user.password == password
          render :json => {:result => 1, :message => '登陆成功！', :user => user.to_json(:except => [:created_at, :update_at])}
        else
          render :json => {:result => 0, :message => '密码错误！'}
        end
      else
        render :json => {:result => 0, :message => '账号不存在！'}
      end
    else
      render :json => {:result => 0, :message => '账号或密码为空，请检查输入！'}
    end
  end

end
