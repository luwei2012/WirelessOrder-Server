# -*- encoding : utf-8 -*-
class CreateDishStyles < ActiveRecord::Migration
  def change
    create_table :dish_styles do |t|
      t.string :name
      t.string :describe

      t.timestamps
    end
  end
end
