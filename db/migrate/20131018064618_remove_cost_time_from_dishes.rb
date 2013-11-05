# -*- encoding : utf-8 -*-
class RemoveCostTimeFromDishes < ActiveRecord::Migration
  def change
    remove_column :dishes, :cost_time, :datetime
  end
end
