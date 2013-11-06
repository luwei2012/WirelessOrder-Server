# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  validates :account, :password, presence: true
  validates :name, length: {minimum: 2}
  validates :account, uniqueness: true
  validates :password, length: {minimum: 6}, confirmation: true
  validates :password_confirmation, presence: true
  attr_accessor :old_password, :new_password
  NORMAL_USER = 0 #普通用户
  NORMAL_ADMIN = 1 #管理员
  SUPER_ADMIN = 2 #超级管理员

end
