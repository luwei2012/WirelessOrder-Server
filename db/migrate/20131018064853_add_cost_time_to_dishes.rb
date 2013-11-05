# -*- encoding : utf-8 -*-
class AddCostTimeToDishes < ActiveRecord::Migration
  def change
    add_column :dishes, :cost_time, :integer
  end
end
