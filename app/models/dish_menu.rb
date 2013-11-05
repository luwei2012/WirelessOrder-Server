# -*- encoding : utf-8 -*-
class DishMenu < ActiveRecord::Base
  belongs_to :dish
  belongs_to :menu
end
