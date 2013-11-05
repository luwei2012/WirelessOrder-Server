# -*- encoding : utf-8 -*-
class Menu < ActiveRecord::Base
  belongs_to :table
  has_many :dish_menus, dependent: :destroy
  has_many :dishes, through: :dish_menus

  #Menu.status
  #0:未结账
  #1:已结转
  #2:已确认提交
end
