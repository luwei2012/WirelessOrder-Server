# -*- encoding : utf-8 -*-
class CreateDishes < ActiveRecord::Migration
  def change
    create_table :dishes do |t|
      t.string :name
      t.belongs_to :dish_type
      t.integer :price
      t.belongs_to :dish_style
      t.string :remarks
      t.integer :status
      t.integer :count
      t.datetime :cost_time
      t.string :imageUrl
      t.timestamps
    end
  end
end
