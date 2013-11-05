# -*- encoding : utf-8 -*-
class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.belongs_to :table
      t.float :sales
      t.integer :status
      t.timestamps
    end
  end
end
