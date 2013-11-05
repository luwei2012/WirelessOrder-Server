# -*- encoding : utf-8 -*-
class DishStyle < ActiveRecord::Base
  has_many :dishes, dependent: :destroy
end
