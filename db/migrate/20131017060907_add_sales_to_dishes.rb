# -*- encoding : utf-8 -*-
class AddSalesToDishes < ActiveRecord::Migration
  def change
    add_column :dishes, :sales, :float
  end
end
