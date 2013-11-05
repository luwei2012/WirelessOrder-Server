# -*- encoding : utf-8 -*-
class Dish < ActiveRecord::Base
  has_many :dish_menus, dependent: :destroy
  has_many :menus, through: :dish_menus

  belongs_to :dish_style
  belongs_to :dish_type

  #status 0:缺货
  #       1:可点
end
