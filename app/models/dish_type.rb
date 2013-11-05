# -*- encoding : utf-8 -*-
class DishType < ActiveRecord::Base
  has_many :dishes, dependent: :destroy
end
