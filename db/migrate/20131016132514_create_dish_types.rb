# -*- encoding : utf-8 -*-
class CreateDishTypes < ActiveRecord::Migration
  def change
    create_table :dish_types do |t|
      t.string :name
      t.string :describe

      t.timestamps
    end
  end
end
