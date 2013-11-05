# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  validates :account, :password, presence: true
  validates :name, length: {minimum: 2}
  validates :account, length: {minimum: 5}, uniqueness: true
  validates :password, length: {minimum: 6}, confirmation: true
  validates :password_confirmation, presence: true
end
