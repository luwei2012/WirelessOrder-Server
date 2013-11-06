# -*- encoding : utf-8 -*-
class AddRemarksToDishMenus < ActiveRecord::Migration
  def change
    add_column :dish_menus, :remarks, :string
  end
end
