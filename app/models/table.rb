# -*- encoding : utf-8 -*-
class Table < ActiveRecord::Base
  has_many :menus, dependent: :destroy

  #status
  #0 => 空闲
  #1 => 占用
  #2 => 预定
end
