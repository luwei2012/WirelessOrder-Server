# -*- encoding : utf-8 -*-
class CreateDishMenus < ActiveRecord::Migration
  def change
    create_table :dish_menus do |t|
      t.belongs_to :menu
      t.belongs_to :dish
      t.timestamps
    end
  end
end
